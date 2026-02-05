SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpGenerateAtrValidationReport]
@TenantIds nvarchar(max)
AS
BEGIN
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
   --- Shifting all the data into Temporary table 
   --------------------------------------------------------------------------------------------------------------------------------------------------------------------
   CREATE TABLE #TempTenantsTable (Id INT)
    ;WITH SplitValues AS
    (
        SELECT value
        FROM STRING_SPLIT(@TenantIds, ',')
    )
    INSERT INTO #TempTenantsTable (Id)
    SELECT CAST(value AS INT)
    FROM SplitValues

    Select * into #TempNewAtrTempalteTable from Atr..TAtrTemplate where 
    IndigoClientId in (Select IndigoClientId From #TempTenantsTable)

    Select * into #TempNewRiskProfileTable from Atr..TRiskProfile
    where 
    IndigoClientId in (Select IndigoClientId From #TempTenantsTable)

    Select * into #TempNewAtrTable from Atr..TAtr
    where 
    IndigoClientId in (Select IndigoClientId From #TempTenantsTable)

    Select * into #TempOldAtrTemplateTable from FactFind..TAtrTemplate
    where 
    IndigoClientId in (Select IndigoClientId From #TempTenantsTable)

    Select * into #TempOldAtrTemplateCombinedTable from FactFind..TAtrTemplateCombined
    where 
    IndigoClientId in (Select IndigoClientId From #TempTenantsTable)

    Select * into #TempOldAtrQuestionCombinedTable from factfind..TAtrQuestionCombined
    where 
    IndigoClientId in (Select IndigoClientId From #TempTenantsTable)

    Select * into #TempOldAtrAnswerCombinedTable from factfind..TAtrAnswerCombined
    where 
    IndigoClientId in (Select IndigoClientId From #TempTenantsTable)

    
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------



    CREATE TABLE #tempAtrDataAnalysisReport
    (
        Id int identity(1,1) primary key,
        ReportName nvarchar(max),
        ErrorCount int,
        GeneratedDateTime DateTime2,
        ErrorDetails nvarchar(max)
    )




    CREATE TABLE #TAtrRiskProfile
    (
		ATRId int,  
		TenantId int, 
		TemplateId int , 
		GeneratedRiskProfileId int,
		ChosenRiskProfileId int, 
		ChosenRiskProfileName varchar(255), 
		GeneratedRiskProfileName varchar(255),
	)

    CREATE TABLE #TempAtrTemplateFromJson
    (
        AtrTemplateId int,
        IndigoClientId int,
        AtrRiskCode varchar (255),
        Title varchar (255),
        [LowerBand] int,
        [UpperBand] int,
        AppId varchar (50),
        GroupId int,
    )
INSERT INTO #TempAtrTemplateFromJson
    (AtrTemplateId, IndigoClientId, AtrRiskCode, Title, LowerBand, UpperBand, AppId, GroupId)
SELECT t.AtrTemplateId
            , t.IndigoClientId
            , j.[key] AS AtrRiskCode
            , Trim(JSON_VALUE(j.value, '$.Title')) AS Title
            , JSON_VALUE(j.value, '$.LowerBand') AS LowerBand
            , JSON_VALUE(j.value, '$.UpperBand') AS UpperBand
            , t.AppId
            , t.GroupId
FROM #TempNewAtrTempalteTable t WITH (NOLOCK)
    CROSS APPLY OPENJSON(t.RiskProfileJson) j
where t.IsActive = 1 and t.IndigoClientId NOT IN (select IndigoClientId
from #TempTenantsTable as C)
update #TempAtrTemplateFromJson
set LowerBand = 0 where LowerBand is null
update #TempAtrTemplateFromJson
set UpperBand = 0 where UpperBand is null
---------------------------------------------------------------------------
-- Report 1 : An atr template cannot contain duplicate risk profile codes--
---------------------------------------------------------------------------
select t.AtrTemplateId, t.AtrRiskCode, count(*) as duplicateRecords
into #tempReport1Data
from atr..TAtrTemplateRiskProfile t
group by t.AtrTemplateId, t.AtrRiskCode
having count(*) > 1
---------------------------------------------------------------------------------------------------------------------------------------------
--Report 2: If an atr template has risk profile json then template risk profile should match with Tatrtemplateriskprofile and Triskprofile.--
---------------------------------------------------------------------------------------------------------------------------------------------

select t1.AtrTemplateId, t2.IndigoClientId, t1.AtrRiskCode, t2.Name, t1.LowerBand, t1.UpperBand, t2.AppId, t2.GroupId
into #TempAtrTemplateFromActualMapping
from atr..TAtrTemplateRiskProfile t1 join #TempNewRiskProfileTable t2 on t1.RiskProfileId = t2.RiskProfileId 
where t2.IndigoClientId not in ( select IndigoClientId
from #TempTenantsTable as C) 
and t1.AtrTemplateId NOT IN ( select AtrTemplateId from #TempNewAtrTempalteTable where IsActive = 0)
SELECT *
into #missingRecordsToBeLoaded
FROM #TempAtrTemplateFromJson t1
WHERE NOT EXISTS (
    SELECT 1 FROM #TempAtrTemplateFromActualMapping t2
	where t1.AtrTemplateId = t2.AtrTemplateId
	and t1.IndigoClientId = t2.IndigoClientId
	and TRIM(t1.AtrRiskCode) = TRIM(t2.AtrRiskCode)
	and TRIM(REPLACE(t2.[Name], CHAR(9), '')) = TRIM(REPLACE(t1.Title, CHAR(9), ''))
	and t1.LowerBand = t2.LowerBand
	and t1.UpperBand = t2.UpperBand
	and (t1.AppId = t2.AppId or (t1.AppId is null and t2.AppId is null))
	and t1.GroupId = t2.GroupId
)
SELECT *
into #extraRecordsToBeLoaded
FROM #TempAtrTemplateFromActualMapping t1
WHERE NOT EXISTS (
    SELECT 1 FROM #TempAtrTemplateFromJson t2
	where t1.AtrTemplateId = t2.AtrTemplateId
	and t1.IndigoClientId = t2.IndigoClientId
	and TRIM(t1.AtrRiskCode) = TRIM(t2.AtrRiskCode)
	and TRIM(REPLACE(t1.[Name], CHAR(9), '')) = TRIM(REPLACE(t2.Title, CHAR(9), ''))
	and t1.LowerBand = t2.LowerBand
	and t1.UpperBand = t2.UpperBand
	and (t1.AppId = t2.AppId or (t1.AppId is null and t2.AppId is null))
	and t1.GroupId = t2.GroupId
)
-----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Report 3: Every risk profile reference should exist on same group of ATR template or parent group of ATR template group with include subgroups as true--
-----------------------------------------------------------------------------------------------------------------------------------------------------------
create table #tempAtrRiskGroupMapping
(
    Id int identity(1,1),
    AtrTemplateId int,
    AtrGroupId int,
    RiskProfileId int,
    RiskProfileGroupId int,
    RiskProfileGroupIncludeSubgroups bit
);
declare @errorCount as int = 0;
declare @errorLog3 as nvarchar(max) = '';
declare @current_atrTemplateId int;
declare @atr_groupId int;
WITH
    RecursiveCTE
    AS
    (
        -- Base case: Start with each group and its immediate parent
                    SELECT
                GroupId,
                ParentId AS AncestorId
            FROM
                administration..TGroup
            WHERE 
        ParentId IS NOT NULL
        UNION ALL
            -- Recursive case: Find the parent of the current ancestor
            SELECT
                r.GroupId,
                g.ParentId AS AncestorId
            FROM
                RecursiveCTE r
                INNER JOIN
                administration..TGroup g ON r.AncestorId = g.GroupId
            WHERE 
        g.ParentId IS NOT NULL
    )
	select * into #tempGroupParents from RecursiveCTE
    --mapping of atrtemplate group and risk profile groups	 
    insert into #tempAtrRiskGroupMapping
    select t1.AtrTemplateId, t3.GroupId, t2.RiskProfileId, t2.GroupId, t2.IncludeSubGroups
    from atr..TAtrTemplateRiskProfile t1 join #TempNewRiskProfileTable t2 on t1.RiskProfileId = t2.RiskProfileId
	join #TempNewAtrTempalteTable t3 on t1.AtrTemplateId = t3.AtrTemplateId
    --iterate through above temp table and check whether groupIds are valid or not
    declare @current_mappingId int = 1;
    declare @max_mappingId int;
    declare @atrGroupId int;
    declare @riskGroupId int;
    declare @includeSubgroups bit;
    select @max_mappingId = MAX(Id)
    from #tempAtrRiskGroupMapping;
    while(@current_mappingId < @max_mappingId)
		begin
        select @atr_groupId = AtrGroupId
        from #tempAtrRiskGroupMapping
        where Id = @current_mappingId;
        select @riskGroupId = RiskProfileGroupId
        from #tempAtrRiskGroupMapping
        where Id = @current_mappingId;
        if @atr_groupId <> @riskGroupId
			begin
            select @includeSubgroups = RiskProfileGroupIncludeSubgroups
            from #tempAtrRiskGroupMapping
            where Id = @current_mappingId;
            if @includeSubgroups = 0
				begin
                set @errorCount = @errorCount + 1;
                set @errorLog3 = @errorLog3 + (select STRING_AGG( cast(AtrTemplateId as nvarchar) + '-' + cast(RiskProfileId as nvarchar), ',') as combos
                from #tempAtrRiskGroupMapping
                where Id = @current_mappingId)
            end
				else
				begin
                if not exists
					(
						select 1
                from #tempGroupParents
                where GroupId = @atr_groupId and AncestorId = @riskGroupId
					)
					begin
                    set @errorCount = @errorCount + 1;
                    set @errorLog3 = @errorLog3 + (select STRING_AGG( cast(AtrTemplateId as nvarchar) + '-' + cast(RiskProfileId as nvarchar), ',') as combos
                    from #tempAtrRiskGroupMapping
                    where Id = @current_mappingId)
                end
            end
        end
        select @current_mappingId = @current_mappingId + 1;
    end
insert into #tempAtrDataAnalysisReport
values
    ('Risk profile reference does not exist on either same group of ATR template or parent group of ATR template group with include subgroups as true',
        @errorCount,
        GETUTCDATE(),
        'Grouping is not correct for these combination of AtrTemplate-RiskProfile: ' + @errorLog3);
--------------------------------------------------------------------------------------------------
-- Report 4: Risk profile should have unique combination of risk profile name, groupid and appid--
--------------------------------------------------------------------------------------------------
select t.Name, t.GroupId, t.AppId, count(*) as duplicateRecords
into #tempReport2Data
from #TempNewRiskProfileTable t
group by t.Name, t.GroupId, t.AppId
having count(*) > 1

---------------------------------------------------------------------
--Report 5: Groupid of risk profile should exist in its same tenant--
---------------------------------------------------------------------
select t1.RiskProfileId, t1.IndigoClientId as RiskProfileIndigoClientId, t2.GroupId, t2.IndigoClientId as GroupIndigoClientId
into #tempReportData1
from #TempNewRiskProfileTable t1
join administration..TGroup t2
on t1.GroupId = t2.GroupId
where t1.IndigoClientId != t2.IndigoClientId
and t1.IndigoClientId NOT IN (select Id from #TempTenantsTable)
--------------------------------------------------------------------------------------------------------------------------
--Report 6: If Atr is answered then risk profile should match with generated and chosen risk profile references in Tatr --
--------------------------------------------------------------------------------------------------------------------------
select * into #tempReportData2 
from #TempNewAtrTable t1
where (GeneratedRiskProfileId != null and NOT EXISTS (select 1 from #TempNewRiskProfileTable t2 where t1.GeneratedRiskProfileId = t2.RiskProfileId))
or (ChosenRiskProfileId != null and NOT EXISTS (select 1 from #TempNewRiskProfileTable t2 where t2.RiskProfileId = t1.ChosenRiskProfileId))
and t1.IndigoClientId NOT IN (select Id from #TempTenantsTable)
-----------------------------------------------------------------------------
--Report 7: New ATR Templates should have reference with old factfind tables--
-----------------------------------------------------------------------------
select * into #tempReportData3
from
(select t1.AtrTemplateId, t1.MigrationRef 
from #TempNewAtrTempalteTable t1
where MigrationRef is null
and NOT EXISTS ( select 1 from #TempOldAtrTemplateTable t2 where t2.AtrTemplateSyncId = t1.AtrTemplateId)
union
select t1.AtrTemplateId, t1.MigrationRef from #TempNewAtrTempalteTable t1
where MigrationRef is not null
AND NOT EXISTS ( select 1 from #TempOldAtrTemplateTable t2 where t2.AtrTemplateId = REVERSE(SUBSTRING(REVERSE(t1.MigrationRef), 0, CHARINDEX('-', REVERSE(t1.MigrationRef)))))
) as t
--------------------------------------------------------------------------------------
--Report 8: Active ATR Tempaltes should not have reference of Archived Risk Profiles--
--------------------------------------------------------------------------------------
select t1.AtrTemplateId as AtrTempalteId, t2.IsActive as IsActive, t1.RiskProfileId as RiskProfileId, t3.IsArchived  as IsArchived
into #tempReportData4 from Atr..TAtrTemplateRiskProfile t1
join #TempNewAtrTempalteTable t2 on t1.AtrTemplateId = t2.AtrTemplateId
join #TempNewRiskProfileTable t3 on t1.RiskProfileId = t3.RiskProfileId
where t2.IsActive = 1 and t3.IsArchived = 1
and t2.IndigoClientId NOT IN (select Id from #TempTenantsTable)
----------------------------------------------------------------------
--Report 9: Unique AtrTemplateSyncId in factfind..TAtrTemplate table--
----------------------------------------------------------------------
select AtrTemplateSyncId, count(*) as CountId into #tempReportData5 from #TempOldAtrTemplateTable
where AtrTemplateSyncId is not null
group by AtrTemplateSyncId
having count(*) > 1
----------------------------------------------------------------------------------------
--Report 10: Unique AtrInvestmentGeneralSyncId in factfind..TAtrInvestmentGeneral table--
----------------------------------------------------------------------------------------
select AtrInvestmentGeneralSyncId,CrmContactId, count(*) as CountId into #tempReportData6 from factfind..TAtrInvestmentGeneral
where AtrInvestmentGeneralSyncId is not null
group by AtrInvestmentGeneralSyncId,CrmContactId
having count(*) > 1
-----------------------------------------------------------------------------------------
--Report 11: Unique AtrRetirementGeneralSyncId  in factfind..TAtrRetirementGeneral table--
-----------------------------------------------------------------------------------------
select AtrRetirementGeneralSyncId,CrmContactId, count(*) as CountId into #tempReportData7 from factfind..TAtrRetirementGeneral
where AtrRetirementGeneralSyncId is not null
group by AtrRetirementGeneralSyncId,CrmContactId
having count(*) > 1
---------------------------------------------------------------------------------------------------------------------------------------------
--Report 12: Risk profile should have name, group ad mandatory properties.Check grp is not NULL for risk profile
---------------------------------------------------------------------------------------------------------------------------------------------
     select * into #TempRiskProfileWhereGroupIdIsNotNUll from #TempNewRiskProfileTable
  where GroupId is NULL
---------------------------------------------------------------------------------------------------------------------------------------------
--Report 13: Risk profile should have reference in old fact find if it is used in any atr template (FactFind and Policy Management table)
---------------------------------------------------------------------------------------------------------------------------------------------
select PM_TRPC.BriefDescription, FF_ATRT.AtrTemplateId as FactFindAtrTemplateId, ATR_TATRP.AtrTemplateId as AtrTemplateId, ATR_TATRP.RiskProfileName 
into #TempOldAtrFaultedRiskProfiles
from #TempOldAtrTemplateCombinedTable FF_TATC
join policymanagement..TRiskProfileCombined PM_TRPC
on FF_TATC.Guid = PM_TRPC.AtrTemplateGuid
join #TempOldAtrTemplateTable FF_ATRT
on FF_TATC.AtrTemplateId = FF_ATRT.AtrTemplateId
left join ATR..TAtrTemplateRiskProfile ATR_TATRP
on ATR_TATRP.AtrTemplateId = FF_ATRT.AtrTemplateSyncId and PM_TRPC.BriefDescription = ATR_TATRP.RiskProfileName

where (PM_TRPC.BriefDescription IS NULL
OR ATR_TATRP.RiskProfileName IS NULL)
AND ATR_TATRP.AtrTemplateId IS NOT NULL
AND FF_ATRT.AtrTemplateId IS NOT NULL
---------------------------------------------------------------------------------------------------------------------------------------------
---Report 14: Risk profiles should not contain special characters
---------------------------------------------------------------------------------------------------------------------------------------------
select Name,RiskProfileId into #TempRiskProfileWithSpeicalCharacters from #TempNewRiskProfileTable 
where Name LIKE N'%[' + CHAR(9) + CHAR(10) + '~`@#]%'

select COUNT(*) as NumberOfRows from
(
select Name from #TempNewRiskProfileTable 
where Name LIKE N'%[' + CHAR(9) + CHAR(10) + '~`@#]%'
) cnt
---------------------------------------------------------------------------------------------------------------------------------------------
--Report 15: Duplicate risk profile mappings with same template should not exist
---------------------------------------------------------------------------------------------------------------------------------------------
SELECT
AtrTemplateId as AtrTemplateId, RiskProfileId, AtrRiskCode, COUNT(*) as countMapping
into #TempATRDuplicateRiskProfileMapping
FROM
Atr..TAtrTemplateRiskProfile
GROUP BY
AtrTemplateId, RiskProfileId, AtrRiskCode
HAVING
COUNT(*) > 1
----------------------------------------------------------------------------------------------------------------------------------------------------
--Report 16: In requirement table, old risk titles and new risk profile name should be same
---------------------------------------------------------------------------------------------------------------------------------------------------
    Select R.RequirementId into #TempFaultRequirementRecords From Requirement..TRequirement AS R
    Inner join #TempNewRiskProfileTable As T on T.RiskProfileId = R.RiskProfileId
    WHere (R.RiskProfileRiskTitle is not null and R.RiskProfileId is not null and R.RiskProfileRiskTitle != T.Name)


-----------------------------------------------------------------------------------------------------------------------------------------------------------
---Report 17: All the risk profiles that are TRiskProfile table, should be mactched for the Trequirement table Risk Profile reference is there. (join on ID and check)
------------------------------------------------------------------------------------------------------------------------------------------------------------
    Select RequirementId into #TempFaultRequirmentRiskProfileRecords from requirement..TRequirement as R 
    Where R.RiskProfileId is not null and R.RiskProfileId not in (Select RiskProfileId from #TempNewRiskProfileTable
    Where  RiskProfileName = R.RiskProfileName and TenantId = R.TenantId)

------------------------------------------------------------------------------------------------------------------------------------------------------------
-----Report 18: ATR Template questions,answers should exist in old fact find
------------------------------------------------------------------------------------------------------------------------------------------------------------
    SELECT 
        a.AtrTemplateId,
	    QuestionData.Text as QuestionText,
	    AnswerData.Text as AnswerText
        into #NewAtrQuestions
    FROM 
        #TempNewAtrTempalteTable as  a
    CROSS APPLY 
        OPENJSON(a.AtrQuestionAnswerJson) as Questions
    CROSS APPLY 
        OPENJSON(Questions.value, '$') 
        WITH (
            Text NVARCHAR(MAX) '$.Text',
            Answers NVARCHAR(MAX) AS JSON
        ) AS QuestionData
    CROSS APPLY 
        OPENJSON(QuestionData.Answers) 
        WITH (
            Text NVARCHAR(MAX) '$.Text'
        ) AS AnswerData;

	Select * From #NewAtrQuestions as N
	join #TempOldAtrTemplateTable  as OA on OA.AtrTemplateSyncId = N.AtrTemplateId

	Select
	A.AtrTemplateId,
	Q.Description as QuestionText ,
	Ans.Description as AnswerText,
	P.AtrTemplateSyncId
	into #OldAtrQuestions
	from #TempOldAtrTemplateCombinedTable as A
	join #TempOldAtrTemplateTable  as P on P.AtrTemplateId = A.AtrTemplateId
	join  #TempOldAtrQuestionCombinedTable as Q on Q.AtrTemplateGuid = A.Guid
	join #TempOldAtrAnswerCombinedTable as Ans on Ans.AtrQuestionGuid =  Q.Guid

	Select N.AtrTemplateId as AtrTemplateId into #TempFaultAtrQuestionsNotMatchRecords From  #NewAtrQuestions as N
	Left Join  #OldAtrQuestions as O On  N.QuestionText = O.QuestionText and N.AnswerText = O.AnswerText and N.AtrTemplateId = O.AtrTemplateSyncId
	Where O.QuestionText = null or O.AnswerText = null

------------------------------------------------------------------------------------------------------------------------------------------------------------
 --Report 19:For the Generated and Chosen JSON reference name, check the risk profile name is same from TRiskProfile
 ------------------------------------------------------------------------------------------------------------------------------------------------------------
	INSERT INTO #TAtrRiskProfile
	(
		ATRId,  
		TenantId, 
		TemplateId, 
		ChosenRiskProfileName, 
		GeneratedRiskProfileName,
		GeneratedRiskProfileId,
		ChosenRiskProfileId
	)
    SELECT 
        T.AtrId AS AtrId,
        T.IndigoClientId AS TenantId,
        T.AtrTemplateId AS AtrTemplateId,
        (CASE 
            WHEN T.ChosenRiskProfileJson IS NOT NULL 
            THEN JSON_VALUE(T.ChosenRiskProfileJson, '$.Title') 
            ELSE T.ChosenRiskProfileName 
            END) AS ChosenRisktitle,
        (CASE 
            WHEN T.GeneratedRiskProfileJson IS NOT NULL 
            THEN JSON_VALUE(T.GeneratedRiskProfileJson, '$.Title') 
            ELSE T.GeneratedRiskProfileName 
            END) AS GeneratedRiskTitle,
            T.GeneratedRiskProfileId AS GeneratedRiskProfileId,
            T.ChosenRiskProfileId AS ChoosenRiskProfileId
            FROM 
            #TempNewAtrTable T WITH (NOLOCK)
        INNER JOIN 
        #TempTenantsTable AS C WITH (NOLOCK)
        ON 
        C.Id = T.IndigoClientId
        WHERE 
        (T.GeneratedRiskProfileJson IS NOT NULL OR T.ChosenRiskProfileJson IS NOT NULL)
        AND T.GeneratedRiskProfileId IS NOT NULL 
        AND T.ChosenRiskProfileId IS NOT NULL;

	    Select * into #TempFaultAtrGeneratedRiskProfile  from #TempNewRiskProfileTable as R
	    Join #TAtrRiskProfile as M on M.GeneratedRiskProfileId = RiskProfileId
	    Where R.Name != M.GeneratedRiskProfileName and
	    R.IndigoClientId = M.TenantId

	    Select * into #TempFaultAtrChosenRiskProfile from  #TempNewRiskProfileTable as R
	    Join #TAtrRiskProfile as M on M.ChosenRiskProfileId = RiskProfileId
    	Where R.Name != M.ChosenRiskProfileName and
	    R.IndigoClientId = M.TenantId

	    Drop table #TAtrRiskProfile

------------------------------------------------------------------------------------------------------------------------------------------------------------
--- Insert into AtrDetailsData
------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
-- Report 1 : Inserting An atr template cannot contain duplicate risk profile codes--
-------------------------------------------------------------------------------------
        IF EXISTS (Select 1 From #tempReport1Data)
        BEGIN       
            insert into #tempAtrDataAnalysisReport
            values
            ('Duplicate risk profile codes found for an ATR template',
            (select count(*)
            from #tempReport1Data),
            GETUTCDATE(),
            'Duplicate records exist for these AtrTemplateId-AtrRiskCode combinations: ' + (select STRING_AGG(cast(AtrTemplateId as varchar) + '-' + AtrRiskCode, ',') as combos
            from #tempReport1Data));
        END
---------------------------------------------------------------------------------------------------------------------------------------------
--Report 2: Inserting If an atr template has risk profile json then template risk profile should match with Tatrtemplateriskprofile and Triskprofile.--
---------------------------------------------------------------------------------------------------------------------------------------------
            IF EXISTS (Select 1 From #extraRecordsToBeLoaded)
               OR EXISTS (SELECT 1 FROM #missingRecordsToBeLoaded)
            BEGIN   
                declare @extraRecordsRP as int;
                declare @missingRecordsRP as int;
                select @extraRecordsRP = count(*)
                from #extraRecordsToBeLoaded as t;
                select @missingRecordsRP = count(*)
                from #missingRecordsToBeLoaded as t2;
                declare @errorLog as nvarchar(max);
                set @errorLog = '';
                if @missingRecordsRP > 0
                begin
	            set @errorLog = @errorLog + 'Risk profiles not found in Tatrtemplateriskprofile belonging to ' + cast(@missingRecordsRP as varchar) + ' atr templates : ' + (select STRING_AGG(cast(AtrTemplateId as varchar), ',')
                from #missingRecordsToBeLoaded) 
                end
                if @extraRecordsRP > 0
                begin
	            set @errorLog = @errorLog + 'Extra risk profiles mapped found in Tatrtemplateriskprofile belonging to ' + cast(@extraRecordsRP as varchar) + ' atr templates : ' + (select STRING_AGG(cast(AtrTemplateId as varchar), ',')
                from #extraRecordsToBeLoaded)
                end
                insert into #tempAtrDataAnalysisReport
                values
                ('Atr template risk profile json does not match with Tatrtemplateriskprofile and Triskprofile.',
                @extraRecordsRP + @missingRecordsRP,
                GETUTCDATE(),
                @errorLog);
            END

--------------------------------------------------------------------------------------------------
-- Report 4: Inserting Risk profile should have unique combination of risk profile name, groupid and appid--
--------------------------------------------------------------------------------------------------
        IF EXISTS (Select 1 From #tempReport2Data)
        BEGIN   
            insert into #tempAtrDataAnalysisReport
            values
            ('Risk profile name, groupid and appid found not unique',
            (select count(*)
            from #tempReport2Data),
            GETUTCDATE(),
            'Duplicate records exist for these Risk profile name - groupid - appid combinations: ' + (select STRING_AGG(Name + '-' + 
            CASE
	            when GroupId is not null 
	            then     
                CAST(GroupId as varchar)
	            else 'Null'
	            end
                + '-' + 
            CASE
	            when AppId is not null 
	            then 
	            cast(AppId as varchar)
	            else 'Null'
	        end
	,       ',') as combos
            from #tempReport2Data));
        END

---------------------------------------------------------------------
--Report 5: Groupid of risk profile should exist in its same tenant--
---------------------------------------------------------------------
    IF EXISTS (Select 1 From #tempReportData1)
    BEGIN
        insert into #tempAtrDataAnalysisReport
        values
            ('Groupid of risk profile does not exist in its same tenant',
            (select count(*)
            from #tempReportData1),
            GETUTCDATE(),
            'Groupid of risk profile does not exist in its same tenant for these risk profile ids: ' + (select STRING_AGG( RiskProfileId, ',') as r
            from #tempReportData1));
    END

--------------------------------------------------------------------------------------------------------------------------
--Report 6: If Atr is answered then risk profile should match with generated and chosen risk profile references in Tatr --
--------------------------------------------------------------------------------------------------------------------------
    IF EXISTS (Select 1 From #tempReportData2)
    BEGIN
        insert into #tempAtrDataAnalysisReport
        values
        ('Generated or chosen risk profile reference do not exist',
            (select count(*)
            from #tempReportData2),
            GETUTCDATE(),
            'Generated or chosen risk profile reference do not exist for the atr templateIds: ' + (select STRING_AGG( AtrTemplateId, ',') as r
            from #tempReportData2));
    END

-----------------------------------------------------------------------------
--Report 7: New ATR Templates should have reference with old factfind tables--
-----------------------------------------------------------------------------
    IF EXISTS (Select 1 From #tempReportData3)
    BEGIN
        insert into #tempAtrDataAnalysisReport
        values
        ('New ATR Templates dont have reference with old factfind tables',
            (select count(*)
            from #tempReportData3),
            GETUTCDATE(),
            'New ATR Templates dont have reference with old factfind tables for atr template Ids: ' + (select STRING_AGG(cast(AtrTemplateId as varchar), ',')
            from #tempReportData3));
    END    

--------------------------------------------------------------------------------------
--Report 8: Active ATR Tempaltes should not have reference of Archived Risk Profiles--
--------------------------------------------------------------------------------------
        IF EXISTS (Select 1 From #tempReportData4)
        BEGIN
            insert into #tempAtrDataAnalysisReport
            values
            ('Active ATR templates having reference to archived risk profiles',
            (select count(*)
            from #tempReportData4),
            GETUTCDATE(),
            'Records with Active ATRtemplateIds - archived risk profiles: ' + (select STRING_AGG(cast(AtrTempalteId as varchar) + '-' + cast(RiskProfileId as varchar), ',') as combos
            from #tempReportData4));
        END       

----------------------------------------------------------------------
--Report 9: Unique AtrTemplateSyncId in factfind..TAtrTemplate table--
----------------------------------------------------------------------
        IF EXISTS (Select 1 From #tempReportData5)
        BEGIN
            insert into #tempAtrDataAnalysisReport
            values
            ('Unique AtrTemplateSyncId in factfind..TAtrTemplate table',
                (select count(*)
            from #tempReportData5),
            GETUTCDATE(),
            'Old ATR Templates dont have unique AtrSyncId: ' + (select STRING_AGG(cast(AtrTemplateSyncId as varchar), ',')
            from #tempReportData5));
        END 

----------------------------------------------------------------------------------------
--Report 10: Unique AtrInvestmentGeneralSyncId in factfind..TAtrInvestmentGeneral table--
----------------------------------------------------------------------------------------
        IF EXISTS (Select 1 From #tempReportData6)
        BEGIN
            insert into #tempAtrDataAnalysisReport
            values
            ('Unique AtrInvestmentGeneralSyncId in factfind..TAtrInvestmentGeneral table',
                (select count(*)
            from #tempReportData6),
            GETUTCDATE(),
            'Old AtrInvesmentGenralSyncId is not unique: ' + (select STRING_AGG(cast(AtrInvestmentGeneralSyncId as varchar), ',')
            from #tempReportData6));
        END   

-----------------------------------------------------------------------------------------
--Report 11: Inserting Unique AtrRetirementGeneralSyncId  in factfind..TAtrRetirementGeneral table--
-----------------------------------------------------------------------------------------
        IF EXISTS (Select 1 From #tempReportData7)
        BEGIN
            insert into #tempAtrDataAnalysisReport
            values
            ('Unique AtrRetirementGeneralSyncId  in factfind..TAtrRetirementGeneral table',
                (select count(*)
            from #tempReportData7),
            GETUTCDATE(),
            'Old AtrRetirementGenralSyncId is not unique: ' + (select STRING_AGG(cast(AtrRetirementGeneralSyncId as varchar), ',')
            from #tempReportData7));
        END   

---------------------------------------------------------------------------------------------------------------------------------------------
--Report 12: Risk profile should have name, group ad mandatory properties.Check grp is not NULL for risk profile
---------------------------------------------------------------------------------------------------------------------------------------------
        IF EXISTS (Select 1 From #TempRiskProfileWhereGroupIdIsNotNUll)
        BEGIN
            insert into #tempAtrDataAnalysisReport
            values
            ('Risk profile should have name, group ad mandatory properties.Check grp is not NULL for risk profile',
                (select count(*)
            from #TempRiskProfileWhereGroupIdIsNotNUll),
            GETUTCDATE(),
            'Risk Profile group Id should be unique: ' + (select STRING_AGG(cast(RiskProfileId as varchar), ',')
            from #TempRiskProfileWhereGroupIdIsNotNUll));
        END   
---------------------------------------------------------------------------------------------------------------------------------------------
--Report 13: Risk profile should have reference in old fact find if it is used in any atr template (FactFind and Policy Management table)
---------------------------------------------------------------------------------------------------------------------------------------------
        IF EXISTS (Select 1 From #TempOldAtrFaultedRiskProfiles)
        BEGIN
            insert into #tempAtrDataAnalysisReport
            values
            ('Risk profile should have reference in old fact find if it is used in any atr template (FactFind and Policy Management table)',
                (select count(*)
            from #TempOldAtrFaultedRiskProfiles),
            GETUTCDATE(),
            'Fault Atr Template Ids are: ' + (select STRING_AGG(cast(AtrTemplateId as varchar), ',')
            from #TempOldAtrFaultedRiskProfiles));
        END  
---------------------------------------------------------------------------------------------------------------------------------------------
---Report 14: Risk profiles should not contain special characters
---------------------------------------------------------------------------------------------------------------------------------------------
        IF EXISTS (Select 1 From #TempRiskProfileWithSpeicalCharacters)
        BEGIN
            insert into #tempAtrDataAnalysisReport
            values
            ('Risk profiles should not contain special characters',
                (select count(*)
            from #TempRiskProfileWithSpeicalCharacters),
            GETUTCDATE(),
            'Risk Profile Ids which contain speical characters: ' + (select STRING_AGG(cast(RiskProfileId as varchar), ',')
            from #TempRiskProfileWithSpeicalCharacters));
        END  


---------------------------------------------------------------------------------------------------------------------------------------------
--Report 15: Duplicate risk profile mappings with same template should not exist
---------------------------------------------------------------------------------------------------------------------------------------------
        IF EXISTS (Select 1 From #TempATRDuplicateRiskProfileMapping)
        BEGIN
            insert into #tempAtrDataAnalysisReport
            values
            ('Duplicate risk profile mappings with same template should not exist',
                (select count(*)
            from #TempATRDuplicateRiskProfileMapping),
            GETUTCDATE(),
            'AtrTemplateIds contain duplicate ate risk profile mappings: ' + (select STRING_AGG(cast(AtrTemplateId as varchar), ',')
            from #TempATRDuplicateRiskProfileMapping));
        END 

----------------------------------------------------------------------------------------------------------------------------------------------------
-----Report 16: In requirement table, old risk titles and new risk profile name should be same
---------------------------------------------------------------------------------------------------------------------------------------------------
    IF EXISTS (SELECT 1 FROM #TempFaultRequirementRecords)
    BEGIN
        insert into #tempAtrDataAnalysisReport
        values
            ('In requirement table, old risk titles and new risk profile name should be same',
            (select count(*)
            from #TempFaultRequirementRecords),
            GETUTCDATE(),
            'RequirementIds with fault records: ' + (select STRING_AGG( RequirementId, ',') as r
            from #TempFaultRequirementRecords));
    END

-----------------------------------------------------------------------------------------------------------------------------------------------------------
---Report 17: All the risk profiles that are TRiskProfile table, should be mactched for the Trequirement table Risk Profile reference is there. (join on ID and check)
------------------------------------------------------------------------------------------------------------------------------------------------------------
    IF EXISTS (SELECT 1 FROM #TempFaultRequirmentRiskProfileRecords)
    BEGIN
        insert into #tempAtrDataAnalysisReport
        values
            ('All the risk profiles that are TRiskProfile table, should be mactched for the Trequirement table Risk Profile reference is there.',
            (select count(*)
            from #TempFaultRequirmentRiskProfileRecords),
            GETUTCDATE(),
            'RequirementIds with fault records: ' + (select STRING_AGG( RequirementId, ',') as r
            from #TempFaultRequirmentRiskProfileRecords));
    END
------------------------------------------------------------------------------------------------------------------------------------------------------------
-----Report 18: ATR Template questions,answers should exist in old fact find
------------------------------------------------------------------------------------------------------------------------------------------------------------
    IF EXISTS (SELECT 1 FROM #TempFaultAtrQuestionsNotMatchRecords)
    BEGIN
        insert into #tempAtrDataAnalysisReport
        values
            ('In requirement table, old risk titles and new risk profile name should be same',
            (select count(*)
            from #TempFaultAtrQuestionsNotMatchRecords),
            GETUTCDATE(),
            'AtrTemplateIds with fault records: ' + (select STRING_AGG( AtrTemplateId, ',') as r
            from #TempFaultAtrQuestionsNotMatchRecords));
    END
------------------------------------------------------------------------------------------------------------------------------------------------------------
 --Report 19:For the Generated and Chosen JSON reference name, check the risk profile name is same from TRiskProfile
 ------------------------------------------------------------------------------------------------------------------------------------------------------------
    IF EXISTS (SELECT 1 FROM #TempFaultAtrGeneratedRiskProfile)
    BEGIN
        insert into #tempAtrDataAnalysisReport
        values
            ('For the Generated JSON reference name, check the risk profile name is same from TRiskProfile',
            (select count(*)
            from #TempFaultAtrGeneratedRiskProfile),
            GETUTCDATE(),
            'AtrId with fault records: ' + (select STRING_AGG( ATRId, ',') as r
            from #TempFaultAtrGeneratedRiskProfile));
    END
------------------------------------------------------------------------------------------------------------------------------------------------------------
 --Report 19:For the Generated and Chosen JSON reference name, check the risk profile name is same from TRiskProfile
 ------------------------------------------------------------------------------------------------------------------------------------------------------------
    IF EXISTS (SELECT 1 FROM #TempFaultAtrChosenRiskProfile)
    BEGIN
        insert into #tempAtrDataAnalysisReport
        values
            ('For the Chosen JSON reference name, check the risk profile name is same from TRiskProfile',
            (select count(*)
            from #TempFaultAtrChosenRiskProfile),
            GETUTCDATE(),
            'AtrId with fault records: ' + (select STRING_AGG( ATRId, ',') as r
            from #TempFaultAtrChosenRiskProfile));
    END

    Select * from #tempAtrDataAnalysisReport
END
GO