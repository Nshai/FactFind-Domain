SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[SpNCustomRetrieveFinancialPlanningFundsAndAssets] (@policyBusinessId bigint, @selectedInvestmentId bigint)  
  
as  
  
set nocount on   
  
declare @totalValue float  
  
set @totalValue =   
(   
  
 select isnull(sum(a.total),0) from   
 (  
  select tpbf.currentprice*sum(tpbft.unitquantity) as total  
  from policymanagement..tpolicybusinessfund tpbf  
  inner join policymanagement..tpolicybusinessfundtransaction tpbft on tpbft.policybusinessfundid = tpbf.policybusinessfundid  
  where tpbf.policybusinessid =  @policyBusinessId  
  group by tpbf.currentprice  
 ) a  
   
) + (  
   
 select isnull(sum(ta.Amount),0) as total  
 from FactFind.dbo.tAssets ta  
 where ta.policybusinessid = @policyBusinessId --and ta.crmcontactid = @crmContactId  
   
)  
  
select   
cast(tpbf.PolicyBusinessFundId as varchar(50)) + '_Fund' as UniqueIdentifier,
tpbf.PolicyBusinessFundId,   
tpbf.PolicyBusinessId,   
tpbf.FundId,   
tpbf.FundName,  
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
cast(isnull(round(tpbf.currentprice*sum(tpbft.unitquantity),2), 0) as varchar) as TotalValue,   
isnull(convert(varchar(24),tpbf.lastpricechangedate,120), '') as LastPriceChangeDate,  
case   
 when @totalValue > 0 then  
  round(isnull((tpbf.currentprice*sum(tpbft.unitquantity)/@totalValue)*100,0),2)  
 else 0  
end as  PercentHolding,  
tpbf.CategoryId AS CategoryId,  
tpbf.CategoryName AS CategoryName,
case when fpsf.policybusinessfundid is not null then 1 else 0 end as selected , 
case when fpsf.policybusinessfundid is not null then 'checked' else '' end as checked,
isnull(FinancialPlanningSelectedInvestmentsId,@selectedInvestmentId) as FinancialPlanningSelectedInvestmentsId
from policymanagement..tpolicybusinessfund tpbf    
left join policymanagement..tpolicybusinessfundtransaction tpbft on tpbft.policybusinessfundid = tpbf.policybusinessfundid  
left join TFinancialPlanningSelectedFunds fpsf on fpsf.policybusinessfundid = tpbf.policybusinessfundid and IsAsset = 0 and fpsf.FinancialPlanningSelectedInvestmentsId = @selectedInvestmentId
where tpbf.policybusinessid = @policyBusinessId  
  
group by cast(tpbf.PolicyBusinessFundId as varchar(50)) + '_Fund',tpbf.PolicyBusinessFundId,tpbf.PolicyBusinessId, tpbf.fundid, tpbf.FundName, tpbf.FundTypeId, tpbf.FromFeedFg, tpbf.FundIndigoClientId, tpbf.lastunitchangedate, tpbf.currentprice, tpbf.lastpricechangedate, tpbf.CategoryId, tpbf.CategoryName ,case when fpsf.policybusinessfundid is not null then 1 else 0 end,case when fpsf.policybusinessfundid is not null then 'checked' else '' end,FinancialPlanningSelectedInvestmentsId
  
union all  
  
select   
cast(ta.AssetsId as varchar(50)) + '_Asset' as uniqueIdenitifier,
ta.AssetsId as PolicyBusinessFundId,   
policybusinessid,
ta.AssetsId as FundId,   
ta.Description as FundName,  
0 as FundTypeId,  
null as FromFeedFg,
'Asset' as Type,  
null as FundIndigoClientId,  
cast('n/a' as varchar) as UnitQuantity,  
null as LastUnitChangeDate,   
isnull(ta.amount, 0) CurrentPrice,  
cast(isnull(ta.amount, 0) as varchar) TotalValue,  
isnull(convert(varchar(24),ta.valuedon,120), '') as LastPriceChangeDate,  
case   
 when @totalValue > 0 then  
  round(isnull((ta.amount/@totalValue)*100,0),2)  
 else 0  
end as  PercentHolding,  
ta.AssetCategoryId AS CategoryId,  
tac.SectorName AS CategoryName, 
case when fpsf.policybusinessfundid is not null then 1 else 0 end as selected ,
case when fpsf.policybusinessfundid is not null then 'checked' else '' end as checked,
isnull(FinancialPlanningSelectedInvestmentsId,@selectedInvestmentId) as FinancialPlanningSelectedInvestmentsId
from FactFind.dbo.tAssets ta  
INNER JOIN FactFind.dbo.TAssetCategory tac ON ta.AssetCategoryId = tac.AssetCategoryId  
left join TFinancialPlanningSelectedFunds fpsf on fpsf.PolicyBusinessFundId = ta.AssetsId and IsAsset = 1  and fpsf.FinancialPlanningSelectedInvestmentsId = @selectedInvestmentId
where ta.policybusinessid = @policyBusinessId  


GO
