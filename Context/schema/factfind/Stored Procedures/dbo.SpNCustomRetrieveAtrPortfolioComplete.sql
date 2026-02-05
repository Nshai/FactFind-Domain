SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNCustomRetrieveAtrPortfolioComplete]
	@AtrPortfolioGuid uniqueidentifier,
	@IndigoClientId bigint
AS
-- Get the portfolio details
SELECT
	Guid,
	Identifier
FROM
	TAtrPortfolioCombined 
WHERE
	Guid = @AtrPortfolioGuid

-- Portfolio Returns
SELECT 
	PR.AtrPortfolioGuid, PT.Term, PT.Identifier, PR.LowerReturn, PR.MidReturn, PR.UpperReturn
FROM 
	TAtrPortfolioReturnCombined PR 
	JOIN TAtrRefPortfolioTerm PT ON PT.AtrRefPortfolioTermId = PR.AtrRefPortfolioTermId
	JOIN TAtrPortfolioCombined P ON P.Guid = PR.AtrPortfolioGuid		
WHERE	
	PR.AtrPortfolioGuid = @AtrPortfolioGuid

-- get the asset class details
SELECT
	AtrPortfolioGuid,
	Guid,
	Identifier,
	ISNULL(Allocation, 0) AS Allocation
FROM
	TAtrAssetClassCombined
WHERE	
	AtrPortfolioGuid = @AtrPortfolioGuid
ORDER BY
	Ordering,
	Identifier		

-- get the fund feed details
SELECT
	AF.AtrAssetClassGuid,
	FU.UnitLongName AS FundName,
	ISNULL(FS.FundSectorName, 'Unknown') AS Sector,
	FP.FundProviderName AS CompanyName,
	FU.SedolCode AS Sedol,
	FU.MexCode AS MexId,
	AF.Recommended
FROM
	TAtrAssetClassCombined A		
	JOIN TAtrAssetClassFund AF ON AF.AtrAssetClassGuid = A.Guid
	JOIN Fund2..TFundUnit FU ON FU.FundUnitId = AF.FundId
	JOIN Fund2..TFund F ON F.FundId = FU.FundId
	JOIN Fund2..TFundProvider FP ON FP.FundProviderId = F.FundProviderId
	JOIN Fund2..TFundSector FS ON FS.FundSectorId = F.FundSectorId
WHERE	
	A.AtrPortfolioGuid = @AtrPortfolioGuid
	AND AF.IndigoClientId = @IndigoClientId
	AND AF.FromFeed = 1		

UNION

-- get the non fund feed details
SELECT
	A.Guid,
	N.FundName COLLATE Latin1_General_CI_AS AS FundName,
	ISNULL(N.CategoryName, 'Unknown') COLLATE Latin1_General_CI_AS AS Sector,
	N.CompanyName  COLLATE Latin1_General_CI_AS AS CompanyName,
	N.Sedol COLLATE Latin1_General_CI_AS,
	N.MexId COLLATE Latin1_General_CI_AS,
	AF.Recommended
FROM
	TAtrAssetClassCombined A		
	JOIN TAtrAssetClassFund AF ON AF.AtrAssetClassGuid = A.Guid
	JOIN PolicyManagement..TNonFeedFund N ON N.NonFeedFundId = AF.FundId
WHERE	
	A.AtrPortfolioGuid = @AtrPortfolioGuid
	AND AF.IndigoClientId = @IndigoClientId
	AND AF.FromFeed = 0
GO
