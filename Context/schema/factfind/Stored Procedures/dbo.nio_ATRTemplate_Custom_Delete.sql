SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_ATRTemplate_Custom_Delete]  
@Guid uniqueidentifier  
  
  
AS  
  
 DECLARE @StampUser varchar(255),@AtrTemplateId bigint

SELECT @StampUser='999999998'     
  
SET @AtrTemplateId=(SELECT AtrTemplateId FROM TATRTemplate WHERE Guid=@Guid)   
  

  
--Delete AtrTemplateSetting
INSERT TAtrTemplateSettingAudit(
AtrTemplateId,
AtrRefProfilePreferenceId,
OverrideProfile,
LossAndGain,
AssetAllocation,
CostOfDelay,
Report,
AutoCreateOpportunities,
ConcurrencyId,
AtrTemplateSettingId,
StampAction,
StampDateTime,
StampUser)

SELECT AtrTemplateId,
AtrRefProfilePreferenceId,
OverrideProfile,
LossAndGain,
AssetAllocation,
CostOfDelay,
Report,
AutoCreateOpportunities,
ConcurrencyId,
AtrTemplateSettingId,
'D',getdate(),@StampUser
FROM TAtrTemplateSetting
WHERE AtrTemplateId=@AtrTemplateId

DELETE FROM TAtrTemplateSetting
WHERE AtrTemplateId=@AtrTemplateId


--AtrQuestions and Answers
INSERT TAtrAnswerAudit(
Description,
Ordinal,
Weighting,
AtrQuestionGuid,
IndigoClientId,
Guid,
ConcurrencyId,
AtrAnswerId,
StampAction,
StampDateTime,
StampUser)

SELECT A.Description,
A.Ordinal,
A.Weighting,
A.AtrQuestionGuid,
A.IndigoClientId,
A.Guid,
A.ConcurrencyId,
A.AtrAnswerId,
'D',getdate(),@StampUser
FROM TAtrAnswer A
JOIN TAtrQuestion B ON A.AtrQuestionGuid=B.Guid
WHERE B.AtrTemplateGuid=@Guid

DELETE A
FROM TAtrAnswer A
JOIN TAtrQuestion B ON A.AtrQuestionGuid=B.Guid
WHERE B.AtrTemplateGuid=@Guid

INSERT TAtrAnswerCombinedAudit(
AtrAnswerId,
Description,
Ordinal,
Weighting,
AtrQuestionGuid,
IndigoClientId,
IndigoClientGuid,
ConcurrencyId,
Guid,
StampAction,
StampDateTime,
StampUser)

SELECT AtrAnswerId,
A.Description,
A.Ordinal,
A.Weighting,
A.AtrQuestionGuid,
A.IndigoClientId,
A.IndigoClientGuid,
A.ConcurrencyId,
A.Guid,
'D',getdate(),@StampUser
FROM TAtrAnswerCombined A
JOIN TAtrQuestionCombined B ON A.AtrQuestionGuid=B.Guid
WHERE B.AtrTemplateGuid=@Guid


DELETE A
FROM TAtrAnswerCombined A
JOIN TAtrQuestionCombined B ON A.AtrQuestionGuid=B.Guid
WHERE B.AtrTemplateGuid=@Guid



INSERT TAtrQuestionAudit
(Description,
Ordinal,
Investment,
Retirement,
Active,
AtrTemplateGuid,
IndigoClientId,
Guid,
ConcurrencyId,
AtrQuestionId,
StampAction,
StampDateTime,
StampUser)

SELECT Description,
Ordinal,
Investment,
Retirement,
Active,
AtrTemplateGuid,
IndigoClientId,
Guid,
ConcurrencyId,
AtrQuestionId,
'D',getdate(),@StampUser
FROM TAtrQuestion
WHERE AtrTemplateGuid=@Guid

DELETE TAtrQuestion
WHERE AtrTemplateGuid=@Guid

INSERT TAtrQuestionCombinedAudit(
AtrQuestionId,
Description,
Ordinal,
Investment,
Retirement,
Active,
AtrTemplateGuid,
IndigoClientId,
IndigoClientGuid,
ConcurrencyId,
Guid,
StampAction,
StampDateTime,
StampUser)

SELECT AtrQuestionId,
Description,
Ordinal,
Investment,
Retirement,
Active,
AtrTemplateGuid,
IndigoClientId,
IndigoClientGuid,
ConcurrencyId,
Guid,
'D',getdate(),@StampUser
FROM TAtrQuestionCombined
WHERE AtrTemplateGuid=@Guid


DELETE FROM TAtrQuestionCombined
WHERE AtrTemplateGuid=@Guid

--AtrAssetClassFund
INSERT TAtrAssetClassFundAudit(
AtrAssetClassGuid,
FundId,
FundTypeId,
FromFeed,
Recommended,
IndigoClientId,
ConcurrencyId,
AtrAssetClassFundId,
StampAction,
StampDateTime,
StampUser)

SELECT AtrAssetClassGuid,
A.FundId,
A.FundTypeId,
A.FromFeed,
A.Recommended,
A.IndigoClientId,
A.ConcurrencyId,
A.AtrAssetClassFundId,
'D',getdate(),@StampUser
FROM TAtrAssetClassFund A
JOIN TAtrAssetClass B ON A.AtrAssetClassGuid=B.Guid
JOIN TAtrPortfolio C ON B.AtrPortfolioGuid=C.Guid
WHERE C.AtrTemplateGuid=@Guid


DELETE A
FROM TAtrAssetClassFund A
JOIN TAtrAssetClass B ON A.AtrAssetClassGuid=B.Guid
JOIN TAtrPortfolio C ON B.AtrPortfolioGuid=C.Guid
WHERE C.AtrTemplateGuid=@Guid


--TAtrAssetClass
INSERT TAtrAssetClassAudit(
Identifier,
Allocation,
Ordering,
AtrRefAssetClassId,
AtrPortfolioGuid,
Guid,
ConcurrencyId,
AtrAssetClassId,
StampAction,
StampDateTime,
StampUser)

SELECT A.Identifier,
A.Allocation,
A.Ordering,
A.AtrRefAssetClassId,
A.AtrPortfolioGuid,
A.Guid,
A.ConcurrencyId,
A.AtrAssetClassId,
'D',getdate(),@StampUser
FROM TAtrAssetClass A
JOIN TAtrPortfolio B ON A.AtrPortfolioGuid=B.Guid
WHERE B.AtrTemplateGuid=@Guid

DELETE A
FROM TAtrAssetClass A
JOIN TAtrPortfolio B ON A.AtrPortfolioGuid=B.Guid
WHERE B.AtrTemplateGuid=@Guid

--AtrAssetClassCombined
INSERT TAtrAssetClassCombinedAudit(
AtrAssetClassId,
Identifier,
Allocation,
Ordering,
AtrPortfolioGuid,
ConcurrencyId,
Guid,
StampAction,
StampDateTime,
StampUser)

SELECT A.AtrAssetClassId,
A.Identifier,
A.Allocation,
A.Ordering,
A.AtrPortfolioGuid,
A.ConcurrencyId,
A.Guid,
'D',getdate(),@StampUser
FROM TAtrAssetClassCombined A
JOIN TAtrPortfolioCombined B ON A.AtrPortfolioGuid=B.Guid
WHERE B.AtrTemplateGuid=@Guid

DELETE A
FROM TAtrAssetClassCombined A
JOIN TAtrPortfolioCombined B ON A.AtrPortfolioGuid=B.Guid
WHERE B.AtrTemplateGuid=@Guid

--AtrPortfolioReturn
INSERT TAtrPortfolioReturnAudit(
AtrPortfolioGuid,
AtrRefPortfolioTermId,
LowerReturn,
MidReturn,
UpperReturn,
Guid,
ConcurrencyId,
AtrPortfolioReturnId,
StampAction,
StampDateTime,
StampUser)

SELECT A.AtrPortfolioGuid,
A.AtrRefPortfolioTermId,
A.LowerReturn,
A.MidReturn,
A.UpperReturn,
A.Guid,
A.ConcurrencyId,
A.AtrPortfolioReturnId,
'D',getdate(),@StampUser

FROM TAtrPortfolioReturn A
JOIN TAtrPortfolio B On A.AtrPortfolioGuid=B.Guid
WHERE B.AtrTemplateGuid=@Guid

DELETE A
FROM TAtrPortfolioReturn A
JOIN TAtrPortfolio B On A.AtrPortfolioGuid=B.Guid
WHERE B.AtrTemplateGuid=@Guid

--TAtrPortfolioReturnCombined
INSERT TAtrPortfolioReturnCombinedAudit(
AtrPortfolioReturnId,
AtrPortfolioGuid,
AtrRefPortfolioTermId,
LowerReturn,
MidReturn,
UpperReturn,
ConcurrencyId,
Guid,
StampAction,
StampDateTime,
StampUser)

SELECT A.AtrPortfolioReturnId,
A.AtrPortfolioGuid,
A.AtrRefPortfolioTermId,
A.LowerReturn,
A.MidReturn,
A.UpperReturn,
A.ConcurrencyId,
A.Guid,
'D',getdate(),@StampUser
FROM TAtrPortfolioReturnCombined A
JOIN TAtrPortfolioCombined B On A.AtrPortfolioGuid=B.Guid
WHERE B.AtrTemplateGuid=@Guid





--Portfolio
INSERT TAtrPortfolioAudit
(Identifier,
AtrRefPortfolioTypeId,
Active,
AnnualReturn,
Volatility,
AtrTemplateGuid,
IndigoClientId,
Guid,
ConcurrencyId,
AtrPortfolioId,
StampAction,
StampDateTime,
StampUser)
SELECT Identifier,
AtrRefPortfolioTypeId,
Active,
AnnualReturn,
Volatility,
AtrTemplateGuid,
IndigoClientId,
Guid,
ConcurrencyId,
AtrPortfolioId,
'D',getdate(),@StampUser
FROM TAtrPortfolio
WHERE AtrTemplateGuid=@Guid

DELETE FROM TAtrPortfolio
WHERE AtrTemplateGuid=@Guid

INSERT TAtrPortfolioCombinedAudit
 (AtrPortfolioId,
	Identifier,
	AtrRefPortfolioTypeId,
	Active,
	AnnualReturn,
	Volatility,
	AtrTemplateGuid,
	IndigoClientId,
	IndigoClientGuid,
	ConcurrencyId,
	Guid,
	StampAction,
	StampDateTime,
	StampUser)

SELECT AtrPortfolioId,
	Identifier,
	AtrRefPortfolioTypeId,
	Active,
	AnnualReturn,
	Volatility,
	AtrTemplateGuid,
	IndigoClientId,
	IndigoClientGuid,
	ConcurrencyId,
	Guid,
	'D',getdate(),@StampUser
	FROM TAtrPortfolioCombined
	WHERE AtrTemplateGuid=@Guid

DELETE FROM TAtrPortfolioCombined
WHERE AtrTemplateGuid=@Guid


--AtrMatrixTerm
INSERT TAtrMatrixTermAudit(
Identifier,
Ordinal,
Starting,
Ending,
IndigoClientId,
AtrTemplateGuid,
Guid,
ConcurrencyId,
AtrMatrixTermId,
StampAction,
StampDateTime,
StampUser)
SELECT 
Identifier,
Ordinal,
Starting,
Ending,
IndigoClientId,
AtrTemplateGuid,
Guid,
ConcurrencyId,
AtrMatrixTermId,
'D',getdate(),@StampUser
FROM TAtrMatrixTerm
WHERE AtrTemplateGuid=@Guid

DELETE FROM TAtrMatrixTerm
WHERE AtrTemplateGuid=@Guid

INSERT TAtrMatrixTermCombinedAudit
(AtrMatrixTermId,
Identifier,
Ordinal,
Starting,
Ending,
IndigoClientId,
IndigoClientGuid,
AtrTemplateGuid,
ConcurrencyId,
Guid,
StampAction,
StampDateTime,
StampUser)

SELECT AtrMatrixTermId,
Identifier,
Ordinal,
Starting,
Ending,
IndigoClientId,
IndigoClientGuid,
AtrTemplateGuid,
ConcurrencyId,
Guid,
'D',getdate(),@StampUser
FROM TAtrMatrixTermCombined
WHERE AtrTemplateGuid=@Guid

DELETE FROM TAtrMatrixTermCombined
WHERE AtrTemplateGuid=@Guid

--AtrMatrix
INSERT TAtrMatrixAudit(
AtrRefMatrixDurationId,
ImmediateIncome,
IndigoClientId,
RiskProfileGuid,
AtrPortfolioGuid,
AtrTemplateGuid,
AtrMatrixTermGuid,
Guid,
ConcurrencyId,
AtrMatrixId,
StampAction,
StampDateTime,
StampUser)

SELECT AtrRefMatrixDurationId,
ImmediateIncome,
IndigoClientId,
RiskProfileGuid,
AtrPortfolioGuid,
AtrTemplateGuid,
AtrMatrixTermGuid,
Guid,
ConcurrencyId,
AtrMatrixId,
'D',getdate(),@StampUser
FROM TAtrMatrix
WHERE AtrTemplateGuid=@Guid

DELETE FROM TAtrMatrix
WHERE AtrTemplateGuid=@Guid

INSERT TAtrMatrixCombinedAudit(
AtrMatrixId,
ImmediateIncome,
IndigoClientId,
IndigoClientGuid,
RiskProfileGuid,
AtrPortfolioGuid,
AtrTemplateGuid,
AtrMatrixTermGuid,
Guid,
ConcurrencyId,
StampAction,
StampDateTime,
StampUser)

SELECT AtrMatrixId,
ImmediateIncome,
IndigoClientId,
IndigoClientGuid,
RiskProfileGuid,
AtrPortfolioGuid,
AtrTemplateGuid,
AtrMatrixTermGuid,
Guid,
ConcurrencyId,
'D',getdate(),@StampUser

FROM TAtrMatrixCombined
WHERE AtrTemplateGuid=@Guid

DELETE FROM TAtrMatrixCombined
WHERE AtrTemplateGuid=@Guid



--RiskProfile
INSERT PolicyManagement..TRiskProfileAudit(
Descriptor,
BriefDescription,
IndigoClientId,
RiskNumber,
LowerBand,
UpperBand,
AtrTemplateGuid,
Guid,
ConcurrencyId,
RiskProfileId,
StampAction,
StampDateTime,
StampUser)

SELECT Descriptor,
BriefDescription,
IndigoClientId,
RiskNumber,
LowerBand,
UpperBand,
AtrTemplateGuid,
Guid,
ConcurrencyId,
RiskProfileId,
'D',getdate(),@StampUser
FROM PolicyManagement..TRiskProfile
WHERE AtrTemplateGuid=@Guid

DELETE FROM PolicyManagement..TRiskProfile
WHERE AtrTemplateGuid=@Guid

DELETE FROM TATRTemplate WHERE Guid=@Guid  
  
EXEC FactFind..SpNAuditAtrTemplateCombined @StampUser,@AtrTemplateId,'D'
DELETE FROM TATRTemplateCombined WHERE Guid=@Guid  

  
GO
