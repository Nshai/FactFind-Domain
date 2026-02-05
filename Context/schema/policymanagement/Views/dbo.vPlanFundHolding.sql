SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE VIEW [dbo].[vPlanFundHolding]
AS

 /* Holding Descriminator logic
	FromFeedFg = 0 && EquityFg = 0 -> NonFeedFund
    FromFeedFg = 1 && EquityFg = 0 = 1 -> FeedFund
    FromFeedFg = 0 && EquityFg = 1 = 2 -> (Manual)Equity
    FromFeedFg = 1 && EquityFg = 1 = 3 -> (Feed)Equity */

SELECT 
 PolicyBusinessFundId
,PolicyBusinessId
,FundId
,FundTypeId
,FundName
,CategoryId
,CategoryName
,CurrentUnitQuantity
,LastUnitChangeDate
,CurrentPrice
,LastPriceChangeDate
,PriceUpdatedByUser
,FromFeedFg
,FundIndigoClientId
,InvestmentTypeId
,RiskRating
,EquityFg
,ConcurrencyId
,UpdatedByReplicatedProc
,Cost
,LastTransactionChangeDate
,RegularContributionPercentage
,PortfolioName
,ModelPortfolioName
,DFMName
,MigrationReference
, CASE WHEN FromFeedFg = 1 and EquityFg = 0 
		THEN 'F' 
		ELSE CASE WHEN FromFeedFg = 1 and EquityFg = 1 
					THEN 'E' 
					ELSE 'M' 
			 END 
  END + CAST(FundId AS VARCHAR(100)) FundSearchId
  , (Convert(int, FromFeedFg) + Convert(int, EquityFg) * 2) HoldingType
FROM TPolicyBusinessFund 