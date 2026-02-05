SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE dbo.SpCustomRemoveFundFromPolicy
@PolicyBusinessFundId bigint

As

SET NOCOUNT ON    

DECLARE @tx int  
SELECT @tx = @@TRANCOUNT  
IF @tx = 0 BEGIN TRANSACTION TX   


Begin

-- DELETE PolicyBusinessFundTransation records for this @PolicyBusinessFundId
INSERT INTO TPolicyBusinessFundTransactionAudit (PolicyBusinessFundId, TransactionDate, RefFundTransactionTypeId, 
	Gross, Cost, UnitPrice, UnitQuantity, ConcurrencyId, 
	PolicyBusinessFundTransactionId, StampAction, StampDateTime, StampUser)
SELECT pbft.PolicyBusinessFundId, TransactionDate, RefFundTransactionTypeId, 
	Gross, pbft.Cost, UnitPrice, UnitQuantity, pbft.ConcurrencyId, 
	PolicyBusinessFundTransactionId, 'D', getdate(), '0'
FROM TPolicyBusinessFundTransaction pbft
INNER JOIN TPolicyBusinessFund pbf ON pbft.PolicyBusinessFundId = pbf.PolicyBusinessFundId
WHERE pbft.PolicyBusinessFundId = @PolicyBusinessFundId

DELETE FROM pbft
FROM TPolicyBusinessFundTransaction pbft
INNER JOIN TPolicyBusinessFund pbf on pbft.PolicyBusinessFundId = pbf.PolicyBusinessFundId
WHERE pbft.PolicyBusinessFundId = @PolicyBusinessFundId


-- DELETE PolicyBusinessFundAttributes from this @PolicyBusinessFundId
Exec SpCustomDeletePolicyBusinessFundAttributeByPolicyBusinessFundId @PolicyBusinessFundId, '0'


-- DELETE PolicyBusinessFund records for this @PolicyBusinessFundId
INSERT INTO TPolicyBusinessFundAudit (PolicyBusinessId, FundId, FundTypeId, FundName, 
	CategoryId, CategoryName, CurrentUnitQuantity, LastUnitChangeDate, CurrentPrice, 
	LastPriceChangeDate, PriceUpdatedByUser, FromFeedFg, FundIndigoClientId, InvestmentTypeId, RiskRating, 
	ConcurrencyId, PolicyBusinessFundId, StampAction, StampDateTime, StampUser)
SELECT PolicyBusinessId, FundId, FundTypeId, FundName, 
	CategoryId, CategoryName, CurrentUnitQuantity, LastUnitChangeDate, CurrentPrice, 
	LastPriceChangeDate, PriceUpdatedByUser, FromFeedFg, FundIndigoClientId, InvestmentTypeId, RiskRating, 
	ConcurrencyId, PolicyBusinessFundId, 'D', getdate(), '0'
FROM TPolicyBusinessFund
WHERE PolicyBusinessFundId = @PolicyBusinessFundId

DELETE FROM TPolicyBusinessFund
WHERE PolicyBusinessFundId = @PolicyBusinessFundId

IF @@ERROR != 0 GOTO errh  
	IF @tx = 0 COMMIT TRANSACTION TX    
END  
RETURN (0)    

errh:    
IF @tx = 0 ROLLBACK TRANSACTION TX    
RETURN (100)


GO
