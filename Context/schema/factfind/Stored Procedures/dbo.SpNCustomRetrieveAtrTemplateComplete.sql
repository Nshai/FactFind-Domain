SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveAtrTemplateComplete]
	@AtrTemplateGuid uniqueidentifier,
	@IndigoClientId bigint
AS
DECLARE
	@ReferenceGuid uniqueidentifier,
	@BaseGuid uniqueidentifier,
	@AtrTemplateId bigint,
	@BaseModels bit,
	@AtrRefPortfolioTypeId bigint
	
-- Get base template
SELECT	
	@ReferenceGuid = Guid,
	@AtrTemplateId = AtrTemplateId,
	@BaseGuid = BaseAtrTemplate,
	@AtrRefPortfolioTypeId = AtrRefPortfolioTypeId
FROM
	TAtrTemplate
WHERE
	Guid = @AtrTemplateGuid

-- see if base has models
SELECT 
	@BaseModels = HasModels
FROM
	TAtrTemplateCombined
WHERE
	Guid = @BaseGuid

-- Templates
SELECT 
	Guid, AtrTemplateId, Identifier, Descriptor, Active, BaseAtrTemplate
FROM 
	TAtrTemplateCombined 
WHERE 
	Guid = @AtrTemplateGuid

-- Use base template?
IF @BaseGuid IS NOT NULL
	SET @ReferenceGuid = @BaseGuid

-- Risk Profiles
SELECT 
	R.Guid, R.Descriptor, BriefDescription, RiskNumber, LowerBand, UpperBand, AtrTemplateGuid
FROM
	PolicyManagement..TRiskProfileCombined R
WHERE 
	AtrTemplateGuid = @ReferenceGuid
ORDER BY 
	RiskNumber

-- Questions
SELECT 
	Guid, Description, Ordinal, Investment, Retirement, Active, AtrTemplateGuid
FROM 
	TAtrQuestionCombined 
WHERE 
	AtrTemplateGuid = @ReferenceGuid

-- Answers
SELECT 
	A.Guid, A.Description, A.Ordinal, A.Weighting, A.AtrQuestionGuid
FROM 
	TAtrAnswerCombined A 
	JOIN TAtrQuestionCombined Q ON Q.Guid = A.AtrQuestionGuid 
WHERE 
	Q.AtrTemplateGuid = @ReferenceGuid

IF (@BaseGuid IS NOT NULL AND @BaseModels = 1)
	SET @ReferenceGuid = @BaseGuid
ELSE
	SET @ReferenceGuid = @AtrTemplateGuid

-- Portfolios
SELECT 
	Guid, Identifier, AtrRefPortfolioTypeId, Active, AnnualReturn, Volatility, AtrTemplateGuid
FROM 
	TAtrPortfolioCombined 
WHERE 
	AtrTemplateGuid = @ReferenceGuid
	AND (@AtrRefPortfolioTypeId IS NULL OR AtrRefPortfolioTypeId = @AtrRefPortfolioTypeId)

-- PortfolioReturns
SELECT DISTINCT
	PR.AtrPortfolioGuid, PT.Term, PT.Identifier, PR.LowerReturn, PR.MidReturn, PR.UpperReturn
FROM 
	TAtrPortfolioReturnCombined PR 
	JOIN TAtrRefPortfolioTerm PT ON PT.AtrRefPortfolioTermId = PR.AtrRefPortfolioTermId
	JOIN TAtrPortfolioCombined P ON P.Guid = PR.AtrPortfolioGuid		
WHERE 
	P.AtrTemplateGuid = @ReferenceGuid
	AND (@AtrRefPortfolioTypeId IS NULL OR P.AtrRefPortfolioTypeId = @AtrRefPortfolioTypeId)

-- Asset Classes
SELECT 
	A.Guid, A.Identifier, A.Allocation, A.AtrPortfolioGuid
FROM 
	TAtrAssetClassCombined A 
	JOIN TAtrPortfolioCombined P ON P.Guid = A.AtrPortfolioGuid
WHERE 
	P.AtrTemplateGuid = @ReferenceGuid
	AND (@AtrRefPortfolioTypeId IS NULL OR P.AtrRefPortfolioTypeId = @AtrRefPortfolioTypeId)

-- Funds
SELECT
	AF.AtrAssetClassGuid,
	ISNULL(F.UnitLongName, N.FundName) FundName,
	AF.Recommended
FROM
	TAtrPortfolio P
	JOIN TAtrAssetClassCombined A ON A.AtrPortfolioGuid = P.Guid
	JOIN TAtrAssetClassFund AF ON AF.AtrAssetClassGuid = A.Guid
	LEFT JOIN Fund2..TFundUnit F ON F.FundUnitId = AF.FundId AND AF.FromFeed = 1
	LEFT JOIN PolicyManagement..TNonFeedFund N ON N.NonFeedFundId = AF.FundId AND AF.FromFeed = 0
WHERE	
	P.AtrTemplateGuid = @ReferenceGuid
	AND AF.IndigoClientId = @IndigoClientId
	AND (@AtrRefPortfolioTypeId IS NULL OR P.AtrRefPortfolioTypeId = @AtrRefPortfolioTypeId)

-- Matrix
SELECT 
	ImmediateIncome, RiskProfileGuid, AtrPortfolioGuid, A.AtrTemplateGuid, AtrMatrixTermGuid
FROM 
	TAtrMatrixCombined A
	JOIN TAtrPortfolioCombined B ON B.[Guid] = A.AtrPortfolioGuid
WHERE 
	A.AtrTemplateGuid = @ReferenceGuid
	AND (@AtrRefPortfolioTypeId IS NULL OR B.AtrRefPortfolioTypeId = @AtrRefPortfolioTypeId)

-- Settings
SELECT 
	tempSettings.AtrTemplateSettingId,
	tempSettings.AtrTemplateId,
	tempSettings.AtrRefProfilePreferenceId,
	tempSettings.OverrideProfile,
	tempSettings.LossAndGain,
	tempSettings.AssetAllocation,
	tempSettings.CostOfDelay,
	tempSettings.Report,
	tempSettings.AutoCreateOpportunities,
	
	Case When IsNull(baseTempSettings.AtrTemplateId,0) = 0 
		Then tempSettings.ReportLabel
		Else baseTempSettings.ReportLabel
	End As ReportLabel

FROM 
	TAtrTemplateSetting tempSettings
	Inner Join TAtrTemplate temp on temp.AtrTemplateId = tempSettings.AtrTemplateId
	Left Join TAtrTemplate baseTemp on baseTemp.[Guid] = temp.BaseAtrTemplate
	Left Join TAtrTemplateSetting baseTempSettings on baseTempSettings.AtrTemplateId = baseTemp.AtrTemplateId

WHERE 
	tempSettings.AtrTemplateId = @AtrTemplateId

-- Matrix Terms
SELECT * FROM TAtrMatrixTermCombined WHERE AtrTemplateGuid = @ReferenceGuid

-- Access Options
SELECT * FROM TAtrRefAccessOption







GO
