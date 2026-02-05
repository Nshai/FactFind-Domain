SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[SpNCustomUpdateFundUnitQuantity] 

@StampUser varchar (255),
@PolicyBusinessFundId bigint,
@Value  money
  
as  

declare @tenantId int
declare @policyBusinessId int
declare @currentTotal money
declare @transactionUnit money
declare @id bigint

--get the current total
select 
	 @currentTotal		= f.CurrentUnitQuantity
	,@tenantId			= b.IndigoClientId
	,@policyBusinessId	= b.PolicyBusinessId
from 
	policymanagement..TPolicyBusinessFund f
	join policymanagement..TPolicyBusiness b
		on b.PolicyBusinessId = f.PolicyBusinessId
where 
	f.PolicyBusinessFundId = @PolicyBusinessFundId

select	@transactionUnit = @Value - isnull(@currentTotal,0)

--create a transaction record
insert into policymanagement..TPolicyBusinessFundTransaction
(
	PolicyBusinessFundId,
	Gross,
	TransactionDate,
	UnitQuantity,
	TenantId,
	PolicyBusinessId,
	CreatedByUserId,
	UpdatedByUserId
)
select
	@PolicyBusinessFundId,
	0,
	getdate(),
	@transactionUnit,
	@tenantId,
	@policyBusinessId,
	@StampUser,
	@StampUser

select @id = SCOPE_IDENTITY()

insert into policymanagement..tpolicybusinessfundtransactionAudit
(PolicyBusinessFundId,TransactionDate,RefFundTransactionTypeId,Gross,Cost,UnitPrice,UnitQuantity,ConcurrencyId,PolicyBusinessFundTransactionId,StampAction,StampDateTime,StampUser)
select
PolicyBusinessFundId,TransactionDate,RefFundTransactionTypeId,Gross,Cost,UnitPrice,UnitQuantity,ConcurrencyId,PolicyBusinessFundTransactionId,'C',getdate(),@StampUser
from	policymanagement..tpolicybusinessfundtransaction
where	@id = PolicyBusinessFundTransactionId	

--update the policybusinessfund table
insert into PolicyManagement..TPolicyBusinessFundAudit
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
'U',
getdate(),
@StampUser
from	PolicyManagement..TPolicyBusinessFund
where	PolicyBusinessFundId = @PolicyBusinessFundId

update  PolicyManagement..TPolicyBusinessFund
set		CurrentUnitQuantity = (select sum(UnitQuantity) 
							   from policymanagement..TPolicyBusinessFundTransaction 
							   where PolicyBusinessFundId = @PolicyBusinessFundId),
		LastUnitChangeDate = getdate(),
		Cost = PolicyManagement.dbo.FnCustomCalculateFundCost(@tenantId, @PolicyBusinessFundId),
		ConcurrencyId = ConcurrencyId + 1
where	PolicyBusinessFundId = @PolicyBusinessFundId

select * 
from	PolicyManagement..TPolicyBusinessFund
where	PolicyBusinessFundId = @PolicyBusinessFundId

GO
