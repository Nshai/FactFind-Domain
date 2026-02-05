SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create procedure [dbo].[nio_GetMembersAllocationSummary]

@PolicyBusinessId int,
@MemberPartyId int

as

-- Exec nio_GetMembersAllocationSummary 3399027, 2009822


select  pbfo.PolicyBusinessFundOwnerId,
		FundName as FundName,
		FundType as FundType,
		PercentageHeld as PercentageHeld,
		cast(((currentunitQuantity*currentprice)/100) * PercentageHeld as decimal(18,2))  as AmountHeld
from	TMember m
inner join TPolicyBusinessFundOwner pbfo 
	on pbfo.PolicyBusinessId = m.PolicyBusinessId 
		and m.CRMContactId = pbfo.CRMContactId
inner join TPolicyBusinessFund pbf on pbf.PolicyBusinessFundId = pbfo.PolicyBusinessFundId
where	m.PolicyBusinessId = @PolicyBusinessId and
		m.CRMContactId = @MemberPartyId and
		FundType in ('Fund','Equity')
union

select  pbfo.PolicyBusinessFundOwnerId,
		Description,
		FundType,
		PercentageHeld, 	
		-- The asset amount must be converted to the plan currency.
		cast((a.Amount * policymanagement.dbo.FnGetCurrencyRate(a.CurrencyCode, pb.BaseCurrency) * PercentageHeld /100) as decimal(18,2)) as AmountHeld
from	TMember m
inner join TPolicyBusinessFundOwner pbfo 
	on pbfo.PolicyBusinessId = m.PolicyBusinessId 
		and m.CRMContactId = pbfo.CRMContactId
inner join FactFind..TAssets a 
	on a.AssetsId = pbfo.PolicyBusinessFundId
inner join policymanagement..TPolicyBusiness pb 
    on pb.PolicyBusinessId = a.PolicyBusinessId
where	m.PolicyBusinessId = @PolicyBusinessId and
		m.CRMContactId = @MemberPartyId and
		FundType = 'Asset'
GO
