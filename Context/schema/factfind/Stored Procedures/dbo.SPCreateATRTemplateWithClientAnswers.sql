SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Summary
-- Create date:      21/08/2015
-- Description:      FPA:15468-This Store Procedure is used for migrating the old ATR data from tenants 13380 and 14663 to 15234 
--                   DEF-17166 -Fixing the conversion error by modifying data type  from int to varchar of column NewAtrQuestionId in #TAtrAnswersTemp
 
CREATE PROCEDURE [dbo].[SPCreateATRTemplateWithClientAnswers]    
 @NewAtrTemplateId Int  
As  
BEGIN  
BEGIN  TRY  
  
    
SET NOCOUNT ON;   
  
IF OBJECT_ID('tempdb..#TATRQuestionsTemp') IS NOT NULL  
 DROP TABLE #TATRQuestionsTemp  
IF OBJECT_ID('tempdb..#TAtrAnswersTemp') IS NOT NULL  
 DROP TABLE #TAtrAnswersTemp  
IF OBJECT_ID('tempdb..#TAtrRiskProfileTemp') IS NOT NULL  
 DROP TABLE #TAtrRiskProfileTemp  
IF OBJECT_ID('tempdb..#TAtrInvestmentTemp') IS NOT NULL  
 DROP TABLE #TAtrInvestmentTemp  
IF OBJECT_ID('tempdb..#TAtrRetirementTemp') IS NOT NULL  
 DROP TABLE #TAtrRetirementTemp  
IF OBJECT_ID('tempdb..#TAtrRetirementGeneralTemp') IS NOT NULL  
   DROP TABLE #TAtrRetirementGeneralTemp  
IF OBJECT_ID('tempdb..#TATRInvestmentGeneralTemp') IS NOT NULL  
  DROP TABLE #TATRInvestmentGeneralTemp  
   
    
-- Declare Variables    
DECLARE @FactFindAtrTemplateId Int;    
DECLARE @FactFindTemplateGuid UNIQUEIDENTIFIER;    
DECLARE @FactFindIndigoClientGuid UNIQUEIDENTIFIER;    
DECLARE @IndigoClientId Int    
DECLARE @StampUser varchar(255)     
DECLARE @QuestionAnswerJson NVARCHAR(MAX)    
DECLARE @RiskProfileJson NVARCHAR(MAX)    
DECLARE @FactFindCategoryGuid UNIQUEIDENTIFIER;    
DECLARE @FactFindAtrCategoryId Int    
    
    
    
SELECT @StampUser='999999998'      
    
SELECT @QuestionAnswerJson= ATRQuestionAnswerJson, @RiskProfileJson= RiskProfileJson,     
@IndigoClientId= IndigoClientId FROM ATR..TATRTemplate  WITH (NOLOCK)  
WHERE AtrTemplateId=@NewAtrTemplateId    
    
SET @FactFindIndigoClientGuid = (Select Top 1 Guid From administration..TIndigoClient  WITH (NOLOCK)  
where IndigoClientId=@IndigoClientId)    
    
SELECT @FactFindCategoryGuid = Guid, @FactFindAtrCategoryId= AtrCategoryId FROM FACTFIND..TAtrCategory  WITH (NOLOCK)  
WHERE Name='Default'  AND TenantId=@IndigoClientId and TenantGuid=@FactFindIndigoClientGuid  
    
    
-- Create Temporary Tables    
CREATE TABLE  #TATRQuestionsTemp     
(    
QuestionTempId Int Identity(1,1),    
NewAtrQuestionId varchar(100) Not Null,    
Description VARCHAR(max),    
FactFindAtrTemplateId Int,    
IndigoClientId Int,    
QuestionGuid UNIQUEIDENTIFIER    
);    
    
CREATE Table #TAtrAnswersTemp    
(    
AnswerTempId Int Identity(1,1),    
NewAtrAnswerId Varchar(100) Not null,    
Description Varchar(max),    
Weight Int,    
NewAtrQuestionId varchar(100),    
FactFindAtrTemplateId Int,    
IndigoClientId Int,    
AnswerGuid UNIQUEIDENTIFIER,    
QuestionGuid UNIQUEIDENTIFIER    
);    
    
CREATE TABLE  #TAtrRiskProfileTemp    
(    
  RiskProfileTempId Int Identity(1,1),    
  RiskCode Varchar(max),    
  Descriptor Varchar(max),    
  BriefDescription Varchar(max),    
  RiskNumber Int,    
  LowerBand Int,    
  Upperband Int,    
  AtrTemplateGuid UNIQUEIDENTIFIER,    
  IndigoClientId Int,    
  IndigoClientGuid UNIQUEIDENTIFIER,    
  RiskProfileGuid UNIQUEIDENTIFIER    
) 

  CREATE TABLE #TATRInvestmentGeneralTemp  
  (  
 InvestmentTempId INT IDENTITY(1,1),  
 CRMContactId INT NOT NULL,  
 Client1AgreesWithProfile BIT,  
 Client2AgreesWithAnswers BIT,  
 Client2AgreesWithProfile BIT,  
 CalculatedRiskProfile UNIQUEIDENTIFIER,  
 Client1ChosenProfileGuid UNIQUEIDENTIFIER,  
 Client1Notes VARCHAR(Max),  
 WeightingSum INT,  
 LowerBand INT,  
 UPPERBAND INT,  
 TemplateId INT,  
 DateOfRiskAssessment Date,  
 RiskProfileAdjustedDate Datetime,  
 InconsistencyNotes VARCHAR(Max),  
 AtrInvestmentGeneralSyncId INT  
  ) 
  
  CREATE TABLE #TAtrInvestmentTemp     
  (    
  TempId Int IDENTITY(1,1),  
  CrmContactId INT Not null,    
  ATRQuestionId Varchar(100) not null,    
  ATRAnswerId Varchar(100) Not null,    
  IsSelected bit,    
  ATRId Int not null  
  ) 
    
   CREATE TABLE #TATRRetirementGeneralTemp  
  (  
 RetirementTempId INT IDENTITY(1,1),  
 CRMContactId INT NOT NULL,  
 Client1AgreesWithProfile BIT,  
 Client2AgreesWithAnswers BIT,  
 Client2AgreesWithProfile BIT,  
 CalculatedRiskProfile UNIQUEIDENTIFIER,  
 Client1ChosenProfileGuid UNIQUEIDENTIFIER,  
 Client1Notes VARCHAR(Max),  
 WeightingSum INT,  
 LowerBand INT,  
 UPPERBAND INT,  
 TemplateId INT,  
 DateOfRiskAssessment Date,  
 RiskProfileAdjustedDate Datetime,  
 InconsistencyNotes VARCHAR(Max),  
 AtrRetirementGeneralSyncId INT  
  )
  
   CREATE TABLE #TAtrRetirementTemp     
  (    
  TempId Int IDENTITY(1,1),  
  CrmContactId INT Not null,    
  ATRQuestionId Varchar(100) not null,    
  ATRAnswerId Varchar(100) Not null,    
  IsSelected bit,    
  ATRId Int not null  
  )   
   
/* Templates Creation Logic */    
  
    
INSERT FACTFIND..TAtrTemplate(            
Identifier,            
Descriptor,      
HasFreeTextAnswers,          
Active,            
HasModels,            
BaseAtrTemplate,          
AtrRefPortfolioTypeId,          
IndigoClientId,            
Guid,            
IsArchived,        
ConcurrencyId,    
AtrTemplateSyncId)     
    
Select DISTINCT Name, null, 0, 1, 0, null, null,IndigoClientId, NewId(),0, 1,@NewAtrTemplateId From Atr..TatrTemplate   (NOLOCK)  
where AtrTemplateId=@NewAtrTemplateId    
    
SELECT @FactFindAtrTemplateId=SCOPE_IDENTITY();     
    
SET @FactFindTemplateGuid = (Select GUID FROM FACTFIND..TAtrTemplate WHERE      
AtrTemplateId=@FactFindAtrTemplateId);    
    
INSERT FACTFIND..TAtrTemplateCombined(            
Guid,            
AtrTemplateId,            
Identifier,            
Descriptor,     
HasFreeTextAnswers,           
Active,            
HasModels,            
BaseAtrTemplate,            
AtrRefPortfolioTypeId,        
IndigoClientId,            
IndigoClientGuid,            
IsArchived,        
ConcurrencyId)            
    
SELECT DISTINCT Guid,AtrTemplateId, Identifier, Descriptor,HasFreeTextAnswers, Active, HasModels, BaseAtrTemplate, AtrRefPortfolioTypeId,           
  IndigoClientId, @FactFindIndigoClientGuid, IsArchived,1            
FROM FACTFIND..TAtrTemplate   (NOLOCK)       
WHERE AtrTemplateId=@FactFindAtrTemplateId    
    
EXEC FactFind..SpNAuditAtrTemplateCombined @StampUser,@FactFindAtrTemplateId,'C'    
    
EXEC FactFind..SpNAuditAtrTemplate  @StampUser,@FactFindTemplateGuid,'C'      
    
/* templates creation logic is completed */    
    
INSERT INTO #TATRQuestionsTemp(NewAtrQuestionId, Description, FactFindAtrTemplateId, IndigoClientId,     
QuestionGuid)    
SELECT JSON_VALUE(J.value, '$.Id'), TRIM(JSON_VALUE(J.Value,'$.Text')), @FactFindAtrTemplateId,     
@IndigoClientId, NewId()    
FROM OPENJSON(@QuestionAnswerJson) As J    
    
INSERT INTO #TAtrAnswersTemp(NewAtrAnswerId,Description,Weight,NewAtrQuestionId,     
FactFindAtrTemplateId, IndigoClientId, QuestionGuid, AnswerGuid)    
    
SELECT JSON_VALUE(A.value, '$.Id'),    
       TRIM(JSON_VALUE(A.value, '$.Text')),    
    JSON_VALUE(A.Value, '$.Weight'),    
    Tq.NewAtrQuestionId,    
    @FactFindAtrTemplateId,    
    @IndigoClientId,    
    Tq.QuestionGuid,    
    NewId()    
FROM OPENJSON(@QuestionAnswerJson) As B    
CROSS APPLY    
OPENJSON(B.value, '$.Answers') As A    
Inner Join     
#TATRQuestionsTemp tq on tq.NewAtrQuestionId= json_value(B.value, '$.Id')    
    
INSERT Factfind.dbo.TAtrQuestion(         
 Description,        
 Ordinal,        
 Investment,        
 Retirement,        
 Active,        
 AtrTemplateGuid,        
 IndigoClientId,        
 Guid,        
 ConcurrencyId,    
 AtrQuestionSyncId)        
    
 SELECT DISTINCT Description,QuestionTempId,1,1,1,@FactFindTemplateGuid,@IndigoClientId,    
 QuestionGuid,1, NewAtrQuestionId FROM    
 #TATRQuestionsTemp where FactFindAtrTemplateId=@FactFindAtrTemplateId    
    
 INSERT Factfind.dbo.TAtrQuestionCombined(         
 Guid,        
 AtrQuestionId,        
 Description,        
 Ordinal,        
 Investment,        
 Retirement,        
 Active,        
 AtrTemplateGuid,        
 IndigoClientId,        
 IndigoClientGuid,        
 ConcurrencyId)        
    
 SELECT DISTINCT Guid,AtrQuestionId, Q.Description, Ordinal,1,1, 1, @FactFindTemplateGuid,     
 Q.IndigoClientId,@FactFindIndigoClientGuid, 1    
 from Factfind.dbo.TAtrQuestion Q (NOLOCK) Inner join #TATRQuestionsTemp T on Q.Guid=T.QuestionGuid    
 And Q.IndigoClientId=T.IndigoClientId And Q.AtrTemplateGuid=@FactFindTemplateGuid    
    
 INSERT Factfind.dbo.TAtrAnswer(         
 Description,        
 Ordinal,        
 Weighting,        
 AtrQuestionGuid,        
 IndigoClientId,        
 Guid,        
 ConcurrencyId,    
 AtrAnswerSyncId)        
    
 SELECT Description,AnswerTempId,Weight,QuestionGuid,IndigoClientId,AnswerGuid, 1,NewAtrAnswerId    
 from #TAtrAnswersTemp    
    
    
 INSERT Factfind.dbo.TAtrAnswerCombined(         
 Guid,        
 AtrAnswerId,        
 Description,        
 Ordinal,        
 Weighting,        
 AtrQuestionGuid,        
 IndigoClientId,        
 IndigoClientGuid,        
 ConcurrencyId)    
    
 Select DISTINCT A.Guid,A.AtrAnswerId, A.Description, A.Ordinal, A.Weighting,    
 A.AtrQuestionGuid, A.IndigoClientId, @FactFindIndigoClientGuid,1    
 From  Factfind.dbo.TAtrAnswer A  (NOLOCK) Inner join #TAtrAnswersTemp T    
 ON A.Guid=T.AnswerGuid and A.AtrQuestionGuid=T.QuestionGuid    
 And A.IndigoClientId=T.IndigoClientId    
    
    
 Insert Into #TAtrRiskProfileTemp(RiskCode,BriefDescription,Descriptor,RiskNumber,LowerBand,    
  Upperband,AtrTemplateGuid,IndigoClientId,    
  IndigoClientGuid,RiskProfileGuid)    
    
  Select [Key] As Code, TRIM(JSON_VALUE(value, '$.Title')) As Title,    
  TRIM(Json_Value(value, '$.Description')) As Description,    
  JSON_VALUE(Value, '$.Order') As Ordinal,    
  JSON_VALUE(Value, '$.LowerBand') As LowerBand,    
  JSON_VALUE(Value, '$.UpperBand') As UpperBand,    
 @FactFindTemplateGuid, @IndigoClientId, @FactFindIndigoClientGuid, NewId()    
 FROM OPENJSON(@RiskprofileJson);    
  
 INSERT PolicyManagement..TRiskProfile(      
 BriefDescription,   
 Descriptor,  
 IndigoClientId,      
 RiskNumber,      
 LowerBand,      
 UpperBand,      
 AtrTemplateGuid,      
 Guid,      
 ConcurrencyId,    
 RiskProfileSyncId)      
    
 Select DISTINCT BriefDescription,Descriptor,IndigoClientId,RiskNumber,LowerBand,    
  Upperband,AtrTemplateGuid,RiskProfileGuid,    
  1, RiskCode From #TAtrRiskProfileTemp where AtrTemplateGuid=@FactFindTemplateGuid    
    
    
 INSERT PolicyManagement..TRiskProfileCombined(    
 Guid   ,    
 RiskProfileId,      
 Descriptor,      
 BriefDescription,      
 IndigoClientId,      
 IndigoClientGuid,      
 RiskNumber,      
 LowerBand,      
 UpperBand,      
 AtrTemplateGuid,      
 ConcurrencyId)      
    
 Select DISTINCT Guid,RiskProfileId, TR.Descriptor,TR.BriefDescription,TR.IndigoClientId,@FactFindIndigoClientGuid,     
 TR.RiskNumber,TR.LowerBand,    
  TR.Upperband,TR.AtrTemplateGuid,    
  1 From PolicyManagement..TRiskProfile TR  (NOLOCK)  
  Inner Join #TAtrRiskProfileTemp TT on TR.Guid=TT.RiskProfileGuid    
  And TR.IndigoClientId=TT.IndigoClientId And TR.AtrTemplateGuid=TT.AtrTemplateGuid    
    
    
  INSERT FactfInd..TAtrTemplateSetting(AtrTemplateId,AtrRefProfilePreferenceId,ConcurrencyId)         
  SELECT Top 1 @FactFindAtrTemplateId, CASE     
  When Name = 'PersonalFactFind' Then 1     
  WHEN Name = 'PersonalFactFindInvestment' Or Name='PersonalFactFindRetirement' Then 2    
  ELSE 0 End as SettingId, 1    
  FROM ATR..TATRTag  (NOLOCK)  
  WHERE AtrTemplateId=@NewAtrTemplateId    
  AND Name in ('PersonalFactFind','PersonalFactFindInvestment','PersonalFactFindRetirement')    
    
  /* Client ATR Migration */    
    
     
    
  INSERT INTO #TAtrInvestmentTemp(CRMContactId, ATRQuestionId, ATRAnswerId,IsSelected, AtrId)    
  Select CRMContactId,    
  Q.Id,    
  C.Id,  
  C.Selected,  
  A.AtrId  
  FROM ATR..TATR A    (NOLOCK)  
  CROSS APPLY    
  OpenJSON(A.QuestionAnswerJson) WITH (    
  Id Varchar(100) '$.Id',    
  Answers NVARCHAR(MAX) '$.Answers' As JSON    
  ) Q    
  Cross Apply    
  OpenJSON(Q.Answers) With (    
  Id Varchar(100) '$.Id',    
  Selected BIT '$.Selected'    
  ) C    
  WHERE A.AtrTemplateId=@NewAtrTemplateId    
  AND Context in ('PersonalFactFind','PersonalFactFindInvestment',    
  'TrustFactFind','CorporateFactFind') AND A.IndigoClientId = @IndigoClientId    
    
  UNION    
    
  Select CrmContactId2,    
  Q.Id,    
  C.Id,   
  C.Selected,  
  A.AtrId  
  FROM ATR..TATR A    (NOLOCK)  
  CROSS APPLY    
  OpenJSON(A.QuestionAnswerJson) WITH (    
  Id Varchar(100) '$.Id',    
  Answers NVARCHAR(MAX) '$.Answers' As JSON    
  ) Q    
  Cross Apply    
  OpenJSON(Q.Answers) With (    
  Id Varchar(100) '$.Id',    
  Selected BIT '$.Selected'    
  ) C    
  WHERE A.AtrTemplateId=@NewAtrTemplateId    
  AND Context in ('PersonalFactFind','PersonalFactFindInvestment',    
  'TrustFactFind','CorporateFactFind') AND A.IndigoClientId = @IndigoClientId    
  and A.CrmContactId2 IS NOT NULL;  
    
  WITH LATEST AS (
  Select CrmcontactId, Max(Atrid) as ATRID
  FROM #TAtrInvestmentTemp
  Group by crmcontactId
  )

  DELETE #TAtrInvestmentTemp WHERE CAST(CrmContactId As Varchar(50))+ CAST(ATRId as Varchar(50))
  NOT IN (Select CAST(CrmContactId As Varchar(50))+ CAST(ATRId as
  Varchar(50)) FROM LATEST)
  
  
  DELETE A FROM factfind..TAtrInvestment A Inner join #TAtrInvestmentTemp B  
  ON A.CRMContactId=B.CrmContactId And A.AtrInvestmentSyncId<=B.ATRId   
  AND A.CrmContactId IN (Select C.CRMContactId FROm CRM..TCRMContact C  
  WHERE C.IndClientId=@IndigoClientId)  
    
  INSERT INTO factfind..TAtrInvestment(CRMContactId, AtrQuestionGuid, AtrAnswerGuid, AtrInvestmentSyncId)    
  Select DISTINCT E.CrmContactId, F.QuestionGuid, D.AnswerGuid, E.Atrid FROM
  (
  Select CrmcontactId, ATRQuestionId, Case WHEN ISSelected=1 THEN ATRAnswerId Else NULL END AS AnswerId, AtriD
  FROM
  (Select * from (Select * , ROW_NUMBER() OVER (PARTITION BY CRMCONTACTID, ATRQUESTIOnId Order By ISSelected Desc) As RN
  FROM #TAtrInvestmentTemp) A WHERE RN=1)B) E
  Inner Join #TATRQuestionsTemp F on E.ATRQuestionId=F.NewAtrQuestionId  
  Left join #TAtrAnswersTemp D on E.ATRQuestionId=D.NewAtrQuestionId    
  AND E.AnswerId = D.NewAtrAnswerId  
    
  
    
  INSERT INTO #TAtrRetirementTemp(CRMContactId, ATRQuestionId, ATRAnswerId,IsSelected, AtrId)    
  Select CRMContactId,    
  Q.Id,    
  C.Id,   
  C.Selected,  
  A.AtrId  
  FROM ATR..TATR A    (NOLOCK)   
  CROSS APPLY    
  OpenJSON(A.QuestionAnswerJson) WITH (    
  Id Varchar(100) '$.Id',    
  Answers NVARCHAR(MAX) '$.Answers' As JSON    
  ) Q    
  Cross Apply    
  OpenJSON(Q.Answers) With (    
  Id Varchar(100) '$.Id',    
  Selected BIT '$.Selected'    
  ) C    
  WHERE A.AtrTemplateId=@NewAtrTemplateId    
  AND Context in ('PersonalFactFindRetirement') AND A.IndigoClientId = @IndigoClientId    
    
  UNION    
    
  Select CRMContactId2,    
  Q.Id,    
  C.Id,  
  C.Selected,  
  A.AtrId  
  FROM ATR..TATR A   (NOLOCK)    
  CROSS APPLY    
  OpenJSON(A.QuestionAnswerJson) WITH (    
  Id Varchar(100) '$.Id',    
  Answers NVARCHAR(MAX) '$.Answers' As JSON    
  ) Q    
  Cross Apply    
  OpenJSON(Q.Answers) With (    
  Id Varchar(100) '$.Id',    
  Selected BIT '$.Selected'    
  ) C    
  WHERE A.AtrTemplateId=@NewAtrTemplateId    
  AND Context in ('PersonalFactFindRetirement') AND A.IndigoClientId = @IndigoClientId    
  AND A.CrmContactId2 IS NOT NULL ;  
  
  WITH LATEST AS (
  Select CrmcontactId, Max(Atrid) as ATRID
  FROM #TAtrRetirementTemp
  Group by crmcontactId
  )

  DELETE #TAtrRetirementTemp WHERE CAST(CrmContactId As Varchar(50))+ CAST(ATRId as Varchar(50))
  NOT IN (Select CAST(CrmContactId As Varchar(50))+ CAST(ATRId as
  Varchar(50)) FROM LATEST)  
    
  DELETE A FROM factfind..TAtrRetirement A Inner join #TAtrRetirementTemp B  
  ON A.CRMContactId=B.CrmContactId And A.AtrRetirementSyncId<B.ATRId   
  AND A.CrmContactId IN (Select C.CRMContactId FROm CRM..TCRMContact C  
  WHERE C.IndClientId=@IndigoClientId)  
    
  INSERT INTO factfind..TAtrRetirement(CRMContactId, AtrQuestionGuid, AtrAnswerGuid, AtrRetirementSyncId)    
   Select DISTINCT E.CrmContactId, F.QuestionGuid, D.AnswerGuid, E.Atrid FROM
  (
  Select CrmcontactId, ATRQuestionId, Case WHEN ISSelected=1 THEN ATRAnswerId Else NULL END AS AnswerId, AtriD
  FROM
  (Select * from (Select * , ROW_NUMBER() OVER (PARTITION BY CRMCONTACTID, ATRQUESTIOnId Order By ISSelected Desc) As RN
  FROM #TAtrRetirementTemp) A WHERE RN=1)B) E
  Inner Join #TATRQuestionsTemp F on E.ATRQuestionId=F.NewAtrQuestionId  
  Left join #TAtrAnswersTemp D on E.ATRQuestionId=D.NewAtrQuestionId    
  AND E.AnswerId = D.NewAtrAnswerId 
    
 IF(@FactFindCategoryGuid IS NOT NULL)    
 BEGIN    
    
 INSERT INTO FACTFIND..TAtrCategoryQuestion(AtrCategoryGuid, AtrQuestionGuid, AtrTemplateGuid, ConcurrencyId)    
 SELECT DISTINCT @FactFindCategoryGuid, QuestionGuid, @FactFindTemplateGuid , 1 From    
 #TATRQuestionsTemp WHERE IndigoClientId=@IndigoClientId    
    
 INSERT INTO FACTFIND..TAtrAnswerCategory(AtrCategoryQuestionId, AtrAnswerGuid, Ordinal, Weighting, ConcurrencyId)    
 SELECT DISTINCT A.AtrCategoryQuestionId, B.AnswerGuid, B.AnswerTempId, B.Weight, 1    
 FROM FACTFIND..TAtrCategoryQuestion A Inner Join #TAtrAnswersTemp B   
 on A.AtrQuestionGuid = B.QuestionGuid    
    
 INSERT INTO FACTFIND..TAtrInvestmentCategory(CRMContactId, AtrCategoryId)    
 SELECT DISTINCT CrmContactId, @FactFindAtrCategoryId FROM    
 #TAtrInvestmentTemp  
    
 INSERT INTO FACTFIND..TAtrRetirementCategory(CRMContactId, AtrCategoryId)    
 SELECT DISTINCT CrmContactId, @FactFindAtrCategoryId FROM    
 #TAtrRetirementTemp     
    
 END    
    
  --- General Table    

    
  INSERT INTO #TATRInvestmentGeneralTemp(CRMContactId,Client1AgreesWithProfile, Client2AgreesWithAnswers, Client2AgreesWithProfile,CalculatedRiskProfile,     
  Client1ChosenProfileGuid, Client1Notes, AtrInvestmentGeneralSyncId, WeightingSum,     
  LowerBand, UpperBand, TemplateId, DateOfRiskAssessment, RiskProfileAdjustedDate, InconsistencyNotes)    
    
  SELECT A.CRMContactId, A.AgreedWithGeneratedRiskProfile,Case WHEN A.CrmContactId2 IS NOT NULL THEN 1 ELSE NULL END,    
  Case WHEN A.CrmContactId2 IS NOT NULL THEN 1 ELSE NULL END,    
  B.RiskProfileGuid, C.RiskProfileGuid, A.Notes,    
  A.Atrid,A.Score, B.LowerBand, B.UpperBand,    
  @FactFindAtrTemplateId, A.CompletedAt,A.CompletedAt, A.InconsistencyComments    
  From ATR..TATR A  (NOLOCK)  
  Left JOIN     
  #TAtrRiskProfileTemp B on B.RiskCode=JSON_VALUE(A.GeneratedRiskProfileJson, '$.Code')    
  AND B.AtrTemplateGuid=@FactFindTemplateGuid  
  Left Join    
  #TAtrRiskProfileTemp C on C.RiskCode=JSON_VALUE(A.ChosenRiskProfileJson, '$.Code')    
  AND C.AtrTemplateGuid=@FactFindTemplateGuid   
  Where AtrTemplateId = @NewAtrTemplateId AND     
  Context in ('PersonalFactFind','PersonalFactFindInvestment',    
  'TrustFactFind','CorporateFactFind')     
  AND A.IndigoClientId = @IndigoClientId    
    
  UNION    
    
  SELECT A.CrmContactId2, A.AgreedWithGeneratedRiskProfile,Case WHEN A.CrmContactId2 IS NOT NULL THEN 1 ELSE NULL END,    
  Case WHEN A.CrmContactId2 IS NOT NULL THEN 1 ELSE NULL END,    
  B.RiskProfileGuid, C.RiskProfileGuid, A.Notes,    
  A.Atrid,A.Score,  B.LowerBand, B.UpperBand,    
  @FactFindAtrTemplateId, A.CompletedAt,A.CompletedAt, A.InconsistencyComments    
  From ATR..TATR A   (NOLOCK)  
  Left JOIN     
  #TAtrRiskProfileTemp B on B.RiskCode=JSON_VALUE(A.GeneratedRiskProfileJson, '$.Code')    
  AND B.AtrTemplateGuid=@FactFindTemplateGuid  
  Left Join    
  #TAtrRiskProfileTemp C on C.RiskCode=JSON_VALUE(A.ChosenRiskProfileJson, '$.Code')    
  AND C.AtrTemplateGuid=@FactFindTemplateGuid  
  Where AtrTemplateId = @NewAtrTemplateId AND     
  Context in ('PersonalFactFind','PersonalFactFindInvestment',    
  'TrustFactFind','CorporateFactFind')     
  AND A.IndigoClientId = @IndigoClientId    
  AND A.CrmContactId2 IS NOT NULL    
    
    
 
  
    
  INSERT INTO #TATRRetirementGeneralTemp(CRMContactId,Client1AgreesWithProfile, Client2AgreesWithAnswers, Client2AgreesWithProfile,CalculatedRiskProfile,     
  Client1ChosenProfileGuid, Client1Notes, AtrRetirementGeneralSyncId, WeightingSum,     
  LowerBand, UpperBand, TemplateId, DateOfRiskAssessment, RiskProfileAdjustedDate, InconsistencyNotes)    
    
  SELECT A.CRMContactId, A.AgreedWithGeneratedRiskProfile,Case WHEN A.CrmContactId2 IS NOT NULL THEN 1 ELSE NULL END,    
  Case WHEN A.CrmContactId2 IS NOT NULL THEN 1 ELSE NULL END,    
  B.RiskProfileGuid, C.RiskProfileGuid, A.Notes,    
  A.Atrid,A.Score, B.LowerBand, B.UpperBand,    
  @FactFindAtrTemplateId, A.CompletedAt,A.CompletedAt, A.InconsistencyComments    
  From ATR..TATR A  (NOLOCK)  
  Left JOIN     
  #TAtrRiskProfileTemp B on B.RiskCode=JSON_VALUE(A.GeneratedRiskProfileJson, '$.Code')    
  AND B.AtrTemplateGuid=@FactFindTemplateGuid  
  Left Join    
  #TAtrRiskProfileTemp C on C.RiskCode=JSON_VALUE(A.ChosenRiskProfileJson, '$.Code')    
  AND C.AtrTemplateGuid=@FactFindTemplateGuid  
  Where AtrTemplateId = @NewAtrTemplateId AND     
  Context in ('PersonalFactFindRetirement')     
  AND A.IndigoClientId = @IndigoClientId   
  AND B.AtrTemplateGuid=@FactFindTemplateGuid and  
  C.AtrTemplateGuid=@FactFindTemplateGuid  
    
  UNION    
    
  SELECT A.CrmContactId2, A.AgreedWithGeneratedRiskProfile,Case WHEN A.CrmContactId2 IS NOT NULL THEN 1 ELSE NULL END,    
  Case WHEN A.CrmContactId2 IS NOT NULL THEN 1 ELSE NULL END,    
  B.RiskProfileGuid, C.RiskProfileGuid, A.Notes,    
  A.Atrid,A.Score, B.LowerBand, B.Upperband,    
  @FactFindAtrTemplateId, A.CompletedAt,A.CompletedAt, A.InconsistencyComments    
  From ATR..TATR A   (NOLOCK)  
  Left JOIN     
  #TAtrRiskProfileTemp B on B.RiskCode=JSON_VALUE(A.GeneratedRiskProfileJson, '$.Code')    
  AND B.AtrTemplateGuid=@FactFindTemplateGuid  
  Left Join    
  #TAtrRiskProfileTemp C on C.RiskCode=JSON_VALUE(A.ChosenRiskProfileJson, '$.Code')    
  AND C.AtrTemplateGuid=@FactFindTemplateGuid  
  Where AtrTemplateId = @NewAtrTemplateId AND     
  Context in ('PersonalFactFindRetirement')     
  AND A.IndigoClientId = @IndigoClientId    
  AND A.CrmContactId2 IS NOT NULL    
  AND B.AtrTemplateGuid=@FactFindTemplateGuid and  
  C.AtrTemplateGuid=@FactFindTemplateGuid;  
  
  -- Main tables  
  WITH Latest As (Select *, ROW_NUMBER() OVER (Partition By CrmcontactId Order by AtrInvestmentGeneralSyncId DESC)  
  AS RowNum FROM #TATRInvestmentGeneralTemp)  
  
  DELETE FROM #TATRInvestmentGeneralTemp  
  WHERE InvestmentTempId NOT IN   
  (Select InvestmentTempId FROM Latest Where RowNum=1);  
  
  DELETE A FROM factfind..TAtrInvestmentGeneral A INNER JOIN #TATRInvestmentGeneralTemp B  
  ON A.CRMContactId=B.CRMContactId AND A.AtrInvestmentGeneralSyncId<B.AtrInvestmentGeneralSyncId  
  AND A.CRMContactId in (Select C.CRMContactId FROm CRM..TCRMContact C  
  WHERE C.IndClientId=@IndigoClientId)  
  
  INSERT INTO FACTFIND..TAtrInvestmentGeneral(CRMContactId,Client1AgreesWithProfile, Client2AgreesWithAnswers, Client2AgreesWithProfile,CalculatedRiskProfile,     
  Client1ChosenProfileGuid, Client1Notes, AtrInvestmentGeneralSyncId, WeightingSum,     
  LowerBand, UpperBand, TemplateId, DateOfRiskAssessment, RiskProfileAdjustedDate, InconsistencyNotes)  
  
  SELECT CRMContactId,Client1AgreesWithProfile, Client2AgreesWithAnswers, Client2AgreesWithProfile,CalculatedRiskProfile,     
  Client1ChosenProfileGuid, Client1Notes, AtrInvestmentGeneralSyncId, WeightingSum,     
  LowerBand, UpperBand, TemplateId, DateOfRiskAssessment, RiskProfileAdjustedDate, InconsistencyNotes  
  FROM #TATRInvestmentGeneralTemp  
  WHERE TemplateId=@FactFindAtrTemplateId;  
  
  WITH LatestRetirement As (Select *, ROW_NUMBER() OVER (Partition By CrmcontactId Order by AtrRetirementGeneralSyncId DESC)  
  AS RowNum FROM #TATRRetirementGeneralTemp)  
  DELETE FROM #TATRRetirementGeneralTemp  
  WHERE RetirementTempId NOT IN   
  (Select RetirementTempId FROM LatestRetirement Where RowNum=1);  
  
  
  DELETE A FROM factfind..TAtrRetirementGeneral A INNER JOIN #TATRRetirementGeneralTemp B  
  ON A.CRMContactId=B.CRMContactId AND A.AtrRetirementGeneralSyncId<B.AtrRetirementGeneralSyncId  
  AND A.CRMContactId in (Select C.CRMContactId FROm CRM..TCRMContact C  
  WHERE C.IndClientId=@IndigoClientId)  
  
  INSERT INTO FACTFIND..TAtrRetirementGeneral(CRMContactId,Client1AgreesWithProfile, Client2AgreesWithAnswers, Client2AgreesWithProfile,CalculatedRiskProfile,     
  Client1ChosenProfileGuid, Client1Notes, AtrRetirementGeneralSyncId, WeightingSum,     
  LowerBand, UpperBand, TemplateId, DateOfRiskAssessment, RiskProfileAdjustedDate, InconsistencyNotes)  
  
  SELECT CRMContactId,Client1AgreesWithProfile, Client2AgreesWithAnswers, Client2AgreesWithProfile,CalculatedRiskProfile,     
  Client1ChosenProfileGuid, Client1Notes, AtrRetirementGeneralSyncId, WeightingSum,     
  LowerBand, UpperBand, TemplateId, DateOfRiskAssessment, RiskProfileAdjustedDate, InconsistencyNotes  
  FROM #TAtrRetirementGeneralTemp  
  WHERE TemplateId=@FactFindAtrTemplateId  
     
     
 END TRY  
  
  BEGIN CATCH  
  DECLARE @error int,  
            @message varchar(max),  
            @xstate int;  
       SELECT  
    @error = ERROR_NUMBER(),  
      @message = ERROR_MESSAGE()  
      
       
   RAISERROR ('CreateATRTemplateWithAnswers: %d: %s', 16, 1, @error, @message);  
  
  END CATCH  
  
  DROP TABLE #TATRQuestionsTemp  
  DROP TABLE #TAtrAnswersTemp  
  DROP TABLE #TAtrRiskProfileTemp  
  DROP TABLE #TAtrInvestmentTemp  
  DROP TABLE #TAtrRetirementTemp  
  DROP TABLE #TAtrRetirementGeneralTemp  
  DROP TABLE #TATRInvestmentGeneralTemp  
  
END  
  