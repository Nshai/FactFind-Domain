SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[spNCustomRetrieveFinancialPlanningRevisedFundsDetail] @FinancialPlanningId bigint

as

--
-- TODO: When TPolicyBusinessFundTransaction becomes a synonym to TPolicyBusinessTransaction
--       we need to change this code so that the references to TPolicyBusinessFundTransaction use TenantId
--       because the new table is partitioned by TenantId
--
declare @IsRebalance bit

select @IsRebalance = isnull(RebalanceInvestments,0)
from	TFinancialPlanningScenario 
where financialplanningid = @FinancialPlanningId and PrefferedScenario = 1

--only include this if we are rebalancing
select	InvestmentId,
		cast(a.PolicyBusinessFundId as varchar) as PolicyBusinessFundId,
		FundId,
		null as UnitValue,
		null as FundDetails,		
		FundName,		
		cast(isnull(round(d.currentprice*sum(e.unitquantity),2), 0) as varchar) as CurrentValue,   
		RevisedValue as FutureValue,
		cast(RevisedValue - isnull(round(d.currentprice*sum(e.unitquantity),2), 0) as decimal(18,2)) as BuySell,
		RevisedPercentage,
		d.policybusinessid	
from TFinancialPLanningSelectedFundsRevised a
inner join TFinancialPLanningSelectedFunds b on b.FinancialPlanningSelectedFundsId = a.FinancialPlanningSelectedFundsId
inner join TFinancialPlanningSelectedInvestments c on c.FinancialPlanningSelectedInvestmentsId = b.FinancialPlanningSelectedInvestmentsId
inner join policymanagement..TPolicyBusinessFund d on d.policybusinessfundid = a.policybusinessfundid
left join policymanagement..tpolicybusinessfundtransaction e 
	on e.TenantId = d.FundIndigoClientId
	and e.policybusinessfundid = d.policybusinessfundid  
where FinancialPlanningId = @FinancialPlanningId and IsExecuted = 0 and @IsRebalance = 1
group by InvestmentId,a.PolicyBusinessFundId,RevisedValue,d.currentprice,FundName,FundId,d.policybusinessid,isExecuted,RevisedPercentage

union
--always include this
select  0,
		'999000' + cast(FinancialPlanningAdditionalFundId as varchar),
		a.FundId,
		UnitQuantity,
		FundDetails,
		Name,		
		'0.00',--always 0 as it's a new fund
		case when revisedvalue is null then
			cast(unitquantity*unitprice as decimal(18,2))
		else
			revisedvalue end,
		case when revisedvalue is null then
			cast(cast(unitquantity*unitprice as decimal(18,2))as varchar)
		else
			cast(revisedvalue as varchar) end,
		RevisedPercentage,
		0
from TFinancialPlanningAdditionalFund a
left join fund2..TFundUnit fu on fu.FundUnitId = a.fundid
left join fund2..TFund f on f.fundid = fu.fundid
left join TFinancialPLanningSelectedFundsRevised b on b.policybusinessfundid = '999000' + cast(FinancialPlanningAdditionalFundId as varchar)
where a.FinancialPLanningId = @FinancialPlanningId and isexecuted = 0
order by FundName
GO
