SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure  [dbo].[spNCustomRetrieveFinancialPlanningSelectedFunds] @FinancialPlanningId int
as


declare @totalValue float , @actualFundsValue float, @newFundsValue float, @isRebalance bit

--1	Current Investments/Pensions
--2	New Investment/Pension
select	@isRebalance = isnull(RebalanceInvestments,0) from TFinancialPlanningScenario where FinancialPlanningId = @FinancialPlanningId and prefferedscenario = 1


--set the actual fund values  
set @actualFundsValue = 0

if(@isRebalance = 1) begin
	set @actualFundsValue =   
	( select isnull(sum(a.total),0) from   
	 (  
	  select isnull(tpbf.currentprice*sum(tpbft.unitquantity),0) as total  
	  from policymanagement..tpolicybusinessfund tpbf  
	  inner join policymanagement..tpolicybusinessfundtransaction tpbft on tpbft.policybusinessfundid = tpbf.policybusinessfundid  
	  inner join TFinancialPlanningSelectedFunds c on c.PolicyBusinessFundId = tpbf.PolicyBusinessFundId  and IsAsset = 0
	  inner join TFinancialPlanningSelectedInvestments b on b.FinancialPlanningSelectedInvestmentsId = c.FinancialPlanningSelectedInvestmentsId
	  where b.financialPlanningid = @FinancialPlanningId 
	  group by tpbf.currentprice  
	 ) a)
end
	
--new funds will exists for rebalance and new business
set @newFundsValue = 0
/*(select	isnull(sum(a.total),0) from
	(
		select isnull(UnitQuantity*UnitPrice,0) as total
		from TFinancialPlanningAdditionalFund a
		where a.FinancialPlanningId = @FinancialPLanningId
	) a)
*/
select @totalValue = isnull(@actualFundsValue,0) + isnull(@newFundsValue,0)

if(@isRebalance = 1) begin

	select   
	c.FinancialPlanningSelectedFundsId,
	tpbf.PolicyBusinessFundId,   
	tpbf.PolicyBusinessId,   
	tpbf.FundId,   
	tpbf.FundName, 
	fs.FundSectorName, 
	crm.corporatename + ' - '+ PlanTypeName + case when prodsubtypename is not null then ' (' + prodsubtypename + ')' else '' end as Product,
	tpbf.FundTypeId,  
	tpbf.FromFeedFg,
	case  
	 when tpbf.FundTypeId < 10 then 'Fund'  
	 when tpbf.FundTypeId > 9 then 'Equity'  
	end as Type,  
	isnull(tpbf.FundIndigoClientId,0) as FundIndigoClientId,  
	cast(isnull(round(sum(tpbft.unitquantity),2),0)as varchar) as UnitQuantity,  
	isnull(convert(varchar(24),tpbf.lastunitchangedate,120), '') as LastUnitChangeDate,   
	isnull(round(tpbf.currentprice,2), 0) as CurrentPrice,   
	case when RevisedValue is not null then RevisedValue 
	else	cast(isnull(round(tpbf.currentprice*sum(tpbft.unitquantity),2), 0) as varchar) end as TotalValue,   
	isnull(convert(varchar(24),tpbf.lastpricechangedate,120), '') as LastPriceChangeDate,  
	case   
		when RevisedPercentage is not null then RevisedPercentage
		when @totalValue > 0 then  round(isnull((tpbf.currentprice*sum(tpbft.unitquantity)/@totalValue)*100,0),0)  
		else 0  
	end as  PercentHolding,  

	cast(isnull(round(tpbf.currentprice*sum(tpbft.unitquantity),2), 0) as varchar) as OriginalTotalValue,   
	case   	
		when @totalValue > 0 then  round(isnull((tpbf.currentprice*sum(tpbft.unitquantity)/@totalValue)*100,0),0)  
		else 0  
	end as  OriginalPercentHolding,  

	tpbf.CategoryId AS CategoryId,  
	tpbf.CategoryName AS CategoryName,
	isnull(CrownRating,0) as CrownRating,
	case when FromFeedfg = 1 and EquityFg = 0 then fu.FundUnitId else null end as FundUnitId,
	isnull(FinancialPlanningSelectedFundsRevisedId,0) as FinancialPlanningSelectedFundsRevisedId,
	RevisedValue,
	--isnull(RevisedPercentage,0) as RevisedPercentage,
	case   
		when RevisedPercentage is not null then RevisedPercentage
		when @totalValue > 0 then  round(isnull((tpbf.currentprice*sum(tpbft.unitquantity)/@totalValue)*100,0),0)  
		else 0  
	end as RevisedPercentage,
	isnull(IsLocked,0) as IsLocked,
	0 as isNew
	from policymanagement..tpolicybusinessfund tpbf    
	left join policymanagement..tpolicybusinessfundtransaction tpbft on tpbft.policybusinessfundid = tpbf.policybusinessfundid  
	inner join TFinancialPlanningSelectedFunds c on c.PolicyBusinessFundId = tpbf.PolicyBusinessFundId  and IsAsset = 0
	inner join TFinancialPlanningSelectedInvestments b on b.FinancialPlanningSelectedInvestmentsId = c.FinancialPlanningSelectedInvestmentsId
	left join TFinancialPlanningSelectedFundsRevised r on r.FinancialPlanningSelectedFundsId = c.FinancialPlanningSelectedFundsId
	inner join policymanagement..TPolicyBusiness pb on pb.policybusinessid = tpbf.policybusinessid
	inner join policymanagement..TPolicyDetail pd  on pb.PolicyDetailId = pd.PolicyDetailId
	inner join policymanagement..TPlanDescription pdesc  on pdesc.PlanDescriptionId = pd.PlanDescriptionId
	inner join policymanagement..TRefPlanType2ProdSubType p2p on p2p.RefPlanType2ProdSubTypeId = pdesc.RefPlanType2ProdSubTypeId
	left join policymanagement..TProdSubType pst on pst.prodsubtypeid = p2p.prodsubtypeid
	inner join policymanagement..TRefProdProvider pp on pp.RefProdProviderId = pdesc.RefProdProviderId
	inner join policymanagement..TRefPlanType pt on pt.RefPlanTypeId = p2p.RefPlanTypeId
	inner join crm..TCRMContact crm on crm.crmcontactid = pp.crmcontactid
	left join fund2..TFundUnit fu on fu.FundUnitId = tpbf.fundid
	left join fund2..TFund f on f.fundid = fu.fundid
	left join fund2..TFundSector fs on f.FundSectorId = fs.FundSectorId
	where b.financialPLanningid = @FinancialPlanningId 
	  
	group by c.FinancialPlanningSelectedFundsId,cast(tpbf.PolicyBusinessFundId as varchar(50)) + '_Fund',tpbf.PolicyBusinessFundId,tpbf.PolicyBusinessId, tpbf.fundid, tpbf.FundName,fs.FundSectorName, crm.corporatename + ' - '+ PlanTypeName + case when prodsubtypename is not null then ' (' + prodsubtypename + ')' else '' end,tpbf.FundTypeId, tpbf.FromFeedFg, tpbf.FundIndigoClientId, tpbf.lastunitchangedate, tpbf.currentprice, tpbf.lastpricechangedate, tpbf.CategoryId, tpbf.CategoryName,isnull(CrownRating,0),case when FromFeedfg = 1 and EquityFg = 0 then fu.FundUnitId else null end,FinancialPlanningSelectedFundsRevisedId,RevisedValue,RevisedPercentage,IsLocked

	union

	select   
	-1 as FinancialPlanningSelectedFundsId,
	'999000' + cast(FinancialPlanningAdditionalFundId as varchar) as PolicyBusinessFundId,   --Unique ID
	FinancialPlanningAdditionalFundId as PolicyBusinessId,   
	a.FundId as FundId,   
	fu.unitlongname as FundName,  
	fs.FundSectorName,
	'New Fund' as Product,--crm.corporatename + ' - '+ PlanTypeName as Product,
	null as FundTypeId,  
	null as FromFeedFg,
	null as Type,--case   when tpbf.FundTypeId < 10 then 'Fund'  when tpbf.FundTypeId > 9 then 'Equity' end as Type,  
	null as FundIndigoClientId, --isnull(tpbf.FundIndigoClientId,0) as FundIndigoClientId,  
	cast(isnull(round(a.unitquantity,2),0)as varchar) as UnitQuantity,  
	null as LastUnitChangeDate,   --isnull(convert(varchar(24),tpbf.lastunitchangedate,120), '') as LastUnitChangeDate,   
	isnull(round(a.UnitPrice,2), 0) as CurrentPrice,   
	isnull(RevisedValue,0) as TotalValue,  
	null as LastPriceChangeDate, --isnull(convert(varchar(24),tpbf.lastpricechangedate,120), '') as LastPriceChangeDate,  
	0,

	cast(0 as decimal) as OriginalTotalValue,  
	0,
	null AS CategoryId,  
	null AS  CategoryName,
	isnull(CrownRating,0) AS  CrownRating,
	fu.FundUnitId AS FundUnitId,--case when FromFeedfg = 1 and EquityFg = 0 then fu.FundUnitId else null end as FundUnitId,
	FinancialPlanningSelectedFundsRevisedId,--isnull(FinancialPlanningSelectedFundsRevisedId,0) as FinancialPlanningSelectedFundsRevisedId,
	isnull(RevisedValue,0),
	isnull(RevisedPercentage,0) as RevisedPercentage,
	isnull(IsLocked,0) as IsLocked,
	1 as isNew	
	from TFinancialPlanningAdditionalFund a
	left join fund2..TFundUnit fu on fu.FundUnitId = a.fundid
	left join fund2..TFund f on f.fundid = fu.fundid
	left join fund2..TFundSector fs on f.FundSectorId = fs.FundSectorId
	left join TFinancialPlanningSelectedFundsRevised r on r.PolicyBusinessFundId = '999000' + cast(a.FinancialPlanningAdditionalFundId as varchar)
	where a.FinancialPlanningId = @FinancialPLanningId

	order by fs.FundSectorName

end
else begin

select   
	-1 as FinancialPlanningSelectedFundsId,
	'999000' + cast(FinancialPlanningAdditionalFundId as varchar) as PolicyBusinessFundId,   --Unique ID
	FinancialPlanningAdditionalFundId as PolicyBusinessId,   
	a.FundId as FundId,   
	fu.unitlongname as FundName,  
	fs.FundSectorName,
	'New Fund' as Product,--crm.corporatename + ' - '+ PlanTypeName as Product,
	null as FundTypeId,  
	null as FromFeedFg,
	null as Type,--case   when tpbf.FundTypeId < 10 then 'Fund'  when tpbf.FundTypeId > 9 then 'Equity' end as Type,  
	null as FundIndigoClientId, --isnull(tpbf.FundIndigoClientId,0) as FundIndigoClientId,  
	cast(isnull(round(a.unitquantity,2),0)as varchar) as UnitQuantity,  
	null as LastUnitChangeDate,   --isnull(convert(varchar(24),tpbf.lastunitchangedate,120), '') as LastUnitChangeDate,   
	isnull(round(a.UnitPrice,2), 0) as CurrentPrice,   
	isnull(RevisedValue,0) as TotalValue,  
	null as LastPriceChangeDate, --isnull(convert(varchar(24),tpbf.lastpricechangedate,120), '') as LastPriceChangeDate,  
	0 as PercentHolding,

	0 as OriginalTotalValue,  
	0 as OriginalPercentHolding,
	null AS CategoryId,  
	null AS  CategoryName,
	isnull(CrownRating,0) AS  CrownRating,
	fu.FundUnitId AS FundUnitId,--case when FromFeedfg = 1 and EquityFg = 0 then fu.FundUnitId else null end as FundUnitId,
	FinancialPlanningSelectedFundsRevisedId,--isnull(FinancialPlanningSelectedFundsRevisedId,0) as FinancialPlanningSelectedFundsRevisedId,
	isnull(RevisedValue,0) as RevisedValue,
	isnull(RevisedPercentage,0) as RevisedPercentage,
	isnull(IsLocked,0) as IsLocked,
	1 as isNew
	from TFinancialPlanningAdditionalFund a
	left join fund2..TFundUnit fu on fu.FundUnitId = a.fundid
	left join fund2..TFund f on f.fundid = fu.fundid
	left join fund2..TFundSector fs on f.FundSectorId = fs.FundSectorId
	left join TFinancialPlanningSelectedFundsRevised r on r.PolicyBusinessFundId = '999000' + cast(a.FinancialPlanningAdditionalFundId as varchar)
	where a.FinancialPlanningId = @FinancialPLanningId

	order by fs.FundSectorName

end


GO
