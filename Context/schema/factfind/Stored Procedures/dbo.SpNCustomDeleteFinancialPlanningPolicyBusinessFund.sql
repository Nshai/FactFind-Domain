SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpNCustomDeleteFinancialPlanningPolicyBusinessFund] 

@StampUser varchar (255),
@PolicyBusinessFundId bigint,
@Value  money
  
as  

insert into policymanagement..TPolicyBusinessFundTransactionAudit
(PolicyBusinessFundId,
TransactionDate,
RefFundTransactionTypeId,
Gross,
Cost,
UnitPrice,
UnitQuantity,
ConcurrencyId,
PolicyBusinessFundTransactionId,
StampAction,
StampDateTime,
StampUser)
select 
PolicyBusinessFundId,
TransactionDate,
RefFundTransactionTypeId,
Gross,
Cost,
UnitPrice,
UnitQuantity,
ConcurrencyId,
PolicyBusinessFundTransactionId,
'D',
getdate(),
@StampUser
from	policymanagement..TPolicyBusinessFundTransaction
where	PolicyBusinessFundId = @PolicyBusinessFundId

delete from policymanagement..TPolicyBusinessFundTransaction
where	PolicyBusinessFundId = @PolicyBusinessFundId


insert into policymanagement..TPolicyBusinessFundAudit
(
PolicyBusinessId,
FundId,
FundTypeId,
FundName,
CategoryId,
CategoryName,
CurrentUnitQuantity,
LastUnitChangeDate,
CurrentPrice,
LastPriceChangeDate,
PriceUpdatedByUser,
FromFeedFg,
FundIndigoClientId,
InvestmentTypeId,
RiskRating,
ConcurrencyId,
PolicyBusinessFundId,
StampAction,
StampDateTime,
StampUser
)
select 
PolicyBusinessId,
FundId,
FundTypeId,
FundName,
CategoryId,
CategoryName,
CurrentUnitQuantity,
LastUnitChangeDate,
CurrentPrice,
LastPriceChangeDate,
PriceUpdatedByUser,
FromFeedFg,
FundIndigoClientId,
InvestmentTypeId,
RiskRating,
ConcurrencyId,
PolicyBusinessFundId,
'D',
getdate(),
@StampUser
from policymanagement..TPolicyBusinessFund
where	PolicyBusinessFundId = @PolicyBusinessFundId

delete pbf
from policymanagement..TPolicyBusinessFund pbf
where	PolicyBusinessFundId = @PolicyBusinessFundId


GO
