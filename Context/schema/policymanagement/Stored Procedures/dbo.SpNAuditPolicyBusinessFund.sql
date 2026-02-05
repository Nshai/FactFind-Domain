SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[SpNAuditPolicyBusinessFund]   
@StampUser varchar (255),   
@PolicyBusinessFundId bigint,   
@StampAction char(1)  
AS    

INSERT INTO TPolicyBusinessFundAudit   
	( PolicyBusinessId, FundId, FundTypeId, FundName,
		CategoryId, CategoryName, CurrentUnitQuantity, LastUnitChangeDate,
		CurrentPrice, LastPriceChangeDate, PriceUpdatedByUser, FromFeedFg,
		FundIndigoClientId, InvestmentTypeId, RiskRating, EquityFg,
		ConcurrencyId, UpdatedByReplicatedProc, Cost, LastTransactionChangeDate,
		RegularContributionPercentage, PortfolioName,
		PolicyBusinessFundId, MigrationReference, StampAction, StampDateTime, StampUser)   
Select PolicyBusinessId, FundId, FundTypeId, FundName,
     CategoryId, CategoryName, CurrentUnitQuantity, LastUnitChangeDate,
     CurrentPrice, LastPriceChangeDate, PriceUpdatedByUser, FromFeedFg,
     FundIndigoClientId, InvestmentTypeId, RiskRating, EquityFg,
     ConcurrencyId, UpdatedByReplicatedProc, Cost, LastTransactionChangeDate,
     RegularContributionPercentage,PortfolioName,
     PolicyBusinessFundId, MigrationReference, @StampAction, GetDate(), @StampUser  
FROM TPolicyBusinessFund  
WHERE PolicyBusinessFundId = @PolicyBusinessFundId    

IF @@ERROR != 0 GOTO errh    

RETURN (0)    

errh:  
RETURN (100)
GO
