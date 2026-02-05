SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveNewAtrFactFindDefinition]  
	@IndigoClientId bigint,
	@FactFindId bigint 
AS  
DECLARE   
	@AtrInvestmentTemplateGuid uniqueidentifier,  
	@AtrRetirementTemplateGuid uniqueidentifier,  
	@AtrTemplateGuid1 uniqueidentifier,  
	@AtrTemplateGuid2 uniqueidentifier = null,  
	@AtrTemplateId1 bigint,  
	@AtrTemplateId2 bigint = null, 
	@BaseAtrInvestmentGuid uniqueidentifier, 
	@BaseAtrRetirementGuid uniqueidentifier,  
	@AtrInvestmentTemplateId bigint,  
	@AtrRetirementTemplateId bigint,  
	@SingleAtrTemplateGuid uniqueidentifier,  
	@SingleAtrTemplateBaseGuid uniqueidentifier,  
	@SingleAtrTemplateAtrTemplateId bigint, 
	@AtrTemplatesCount int,
	@IndigoClientGuid uniqueidentifier ,
	@EValueGuid   uniqueidentifier,
	@CRMContactId BIGINT,
	@CRMContactId2 BIGINT;

DECLARE @ActiveAtrTemplates TABLE (AtrTemplateId int, AtrTemplateGuid uniqueidentifier, BaseAtrTemplateGuid uniqueidentifier);
-- Get CRMContactIds 
SELECT
	@CRMContactId = CrmContactId1,
	@CRMContactId2 = CrmContactId2
FROM
	TFactFind
WHERE
	IndigoClientId = @IndigoClientId AND FactFindId = @FactFindId
  
 --Get the IndigoClientGuid  
select @IndigoClientGuid = Guid from administration..TIndigoClient where Indigoclientid = @IndigoClientId  
select @EValueGuid = Guid from administration..TIndigoClientCombined where Identifier = 'Tillinghast'
  
-- Get the active template for this indigo client 
insert @ActiveAtrTemplates
select t.AtrTemplateId, t.Guid, t.BaseAtrTemplate
	from factfind..TAtrTemplate t
	where t.IndigoClientId = @IndigoClientId AND t.Active = 1 

select @AtrTemplatesCount = count(AtrTemplateId) from @ActiveAtrTemplates;

if @AtrTemplatesCount = 1
begin
	SELECT TOP 1   
		@SingleAtrTemplateGuid = a.AtrTemplateGuid,  
		@SingleAtrTemplateBaseGuid = a.BaseAtrTemplateGuid,  
		@SingleAtrTemplateAtrTemplateId = a.AtrTemplateId  
	FROM  
		@ActiveAtrTemplates a 
		
	SELECT @AtrTemplateGuid1 = @SingleAtrTemplateGuid, @AtrTemplateId1 = @SingleAtrTemplateAtrTemplateId;
end		
else
begin 
	SELECT TOP 1
		@AtrInvestmentTemplateGuid = t.AtrTemplateGuid,
		@BaseAtrInvestmentGuid = t.BaseAtrTemplateGuid,
		@AtrInvestmentTemplateId = t.AtrTemplateId
	FROM TAtrInvestmentGeneral g
		LEFT JOIN policymanagement..TRiskProfile p ON p.[Guid] = g.CalculatedRiskProfile OR p.[Guid] = ISNULL(g.Client1ChosenProfileGuid, g.Client2ChosenProfileGuid)		
		LEFT JOIN factfind..TAtrInvestment i ON i.CRMContactId = g.CRMContactId
		LEFT JOIN factfind..TAtrQuestion q ON q.[Guid] = i.AtrQuestionGuid		
		INNER JOIN @ActiveAtrTemplates t ON t.AtrTemplateId = g.TemplateId OR t.AtrTemplateGuid = ISNULL(p.AtrTemplateGuid, q.AtrTemplateGuid)
	WHERE g.CRMContactId in (@CRMContactId, @CRMContactId2)
	ORDER BY (CASE WHEN g.CRMContactId = @CRMContactId THEN 1 ELSE 2 END)

	SELECT TOP 1
		@AtrRetirementTemplateGuid = t.AtrTemplateGuid,
		@BaseAtrRetirementGuid = t.BaseAtrTemplateGuid,
		@AtrRetirementTemplateId = t.AtrTemplateId
	FROM TAtrRetirementGeneral g
		LEFT JOIN policymanagement..TRiskProfile p ON p.[Guid] = g.CalculatedRiskProfile OR p.[Guid] = ISNULL(g.Client1ChosenProfileGuid, g.Client2ChosenProfileGuid)		
		LEFT JOIN factfind..TAtrRetirement i ON i.CRMContactId = g.CRMContactId
		LEFT JOIN factfind..TAtrQuestion q ON q.[Guid] = i.AtrQuestionGuid		
		INNER JOIN @ActiveAtrTemplates t ON t.AtrTemplateId = g.TemplateId OR t.AtrTemplateGuid = ISNULL(p.AtrTemplateGuid, q.AtrTemplateGuid)
	WHERE g.CRMContactId in (@CRMContactId, @CRMContactId2)
	ORDER BY (CASE WHEN g.CRMContactId = @CRMContactId THEN 1 ELSE 2 END)

	select @AtrTemplateGuid1 = @AtrInvestmentTemplateGuid, 
		@AtrTemplateGuid2 = @AtrRetirementTemplateGuid,
		@AtrTemplateId1 = @AtrInvestmentTemplateId,
		@AtrTemplateId2 = @AtrRetirementTemplateId;

end
  
SELECT   
	a.*   ,
	case when b.guid is not null and b.indigoclientguid = @EValueGuid then 1 else 0 end as isEvalue
FROM   
	TAtrTemplate a
	left join TATRTemplateCombined b on b.guid = a.baseatrtemplate
WHERE  
	a.Guid in (@AtrTemplateGuid1, @AtrTemplateGuid2) 
   
-- Get ATR questions and profiles  
EXEC SpNCustomRetrieveNewAtrQuestionDefinition @AtrTemplateGuid1, @AtrTemplateGuid2, @IndigoClientGuid  

SELECT   
	*   
FROM  
	TAtrTemplateSetting  
WHERE  
	AtrTemplateId in (@AtrTemplateId1, @AtrTemplateId2)   
  
-- List all the atr question categories  
SELECT *, CASE WHEN [name] = 'Default' THEN 1 ELSE 0 END AS Chosen 
FROM TATRCategory 
WHERE TenantGuid = @IndigoClientGuid AND IsArchived = 0

SELECT CASE WHEN @AtrTemplatesCount = 1 THEN 1 ELSE 0 END AS HasSingleActiveTemplate
GO
