SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpNCustomScalarAtrProfilesForDuration]
	@AtrTemplateGuid uniqueidentifier,	
	@AtrMatrixTermGuid uniqueidentifier,
	@ImmediateIncome bit,
	@ATRRefPortfolioTypeId int = 2
AS
SELECT
	AtrPortfolioGUID,RiskProfileGuid, cast(RiskNumber as varchar(3)) + ' - ' + BriefDescription +  ' (' + Identifier + ')' as Model,
AnnualReturn,
Volatility,
RiskNumber
FROM
	TAtrMatrixCombined a
	inner join TAtrPortfolioCombined b on b.guid = a.AtrPortfolioGUID
	inner join policymanagement..TRiskProfileCombined c on c.guid = a.riskprofileguid
WHERE
	a.AtrTemplateGuid = @AtrTemplateGuid
	AND AtrMatrixTermGuid = @AtrMatrixTermGuid
	AND ImmediateIncome = @ImmediateIncome
	AND AtrRefPortfolioTypeId = @ATRRefPortfolioTypeId
order by risknumber
GO
