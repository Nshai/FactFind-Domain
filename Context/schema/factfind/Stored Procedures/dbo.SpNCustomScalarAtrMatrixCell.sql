SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomScalarAtrMatrixCell]
	@AtrTemplateGuid uniqueidentifier,
	@RiskProfileGuid uniqueidentifier,
	@AtrMatrixTermGuid uniqueidentifier,
	@ImmediateIncome bit,
	@ATRRefPortfolioTypeid int = 0
AS			

SELECT
	AtrPortfolioGuid
from TAtrMatrixCombined	a
inner join TATRPortfolioCombined b on a.atrportfolioguid = b.guid
WHERE
	a.AtrTemplateGuid = @AtrTemplateGuid
	AND RiskProfileGuid = @RiskProfileGuid
	AND AtrMatrixTermGuid = @AtrMatrixTermGuid
	AND ImmediateIncome = @ImmediateIncome
	AND (atrRefPortfolioTypeId = @ATRRefPortfolioTypeid or @ATRRefPortfolioTypeid =0)
GO
