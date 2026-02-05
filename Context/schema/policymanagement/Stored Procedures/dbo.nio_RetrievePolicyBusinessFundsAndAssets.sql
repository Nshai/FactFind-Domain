SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[nio_RetrievePolicyBusinessFundsAndAssets]
@tenantId bigint,  
@policyBusinessId bigint = 0,    
@policyBusinessIds varchar(max) = '',
@filterCondition varchar(100) = 'current'
AS
SET NOCOUNT ON

SET @policyBusinessIds = REPLACE(@policyBusinessIds, '''', '''''')

declare @sql varchar (max)
select @sql = '
set transaction isolation level read uncommitted
select   
tpbf.PolicyBusinessId,   
tpbf.FundId,         
tpbf.PolicyBusinessFundId,         
tpbf.FundName,        
tpbf.FundTypeId,        
tpbf.FromFeedFg as isFromFeed,      
tpbf.EquityFg as isEquity,          
case        
 when tpbf.FundTypeId <> 8 then ''Fund''        
 when tpbf.FundTypeId = 8 then ''Equity''    
end as HoldingType,        
isnull(tpbf.FundIndigoClientId,0) as FundIndigoClientId,        
isnull(tpbf.CurrentUnitQuantity,0) as UnitQuantity,        
fc.Name FundCategory,
isnull(convert(varchar(24),tpbf.lastunitchangedate,120), null) as LastUnitChangeDate,         
isnull(tpbf.currentprice, 0) as CurrentPrice,         
isnull(tpbf.currentprice * tpbf.CurrentUnitQuantity, 0) as TotalValue,         
isnull(convert(varchar(24),tpbf.lastpricechangedate,120), null) as LastPriceChangeDate,   
tpbf.PriceUpdatedByUser AS PriceUpdatedByUser,       
tpbf.CategoryId AS CategoryId,        
tpbf.CategoryName AS CategoryName,  
tpbf.Cost,' +  
Cast(@tenantId as varchar(50)) + ' as TenantId,  
isnull(convert(varchar(24),tpbf.LastTransactionChangeDate,120), null) as LastTransactionChangeDate,
tpbf.RegularContributionPercentage,
PB.BaseCurrency as CurrencyCode,
IIF(tpbf.EquityFg = 1, fe.EpicCode, IIF(tpbf.FromFeedFg=1, fu.APIRCode, nff.ProviderFundCode)) as APIRCode
from 
	tpolicybusinessfund tpbf   
	JOIN TPolicyBusiness PB ON PB.PolicyBusinessId = tpbf.PolicyBusinessId
	left join fund2..Tentitycategory fec on fec.entityID = tpbf.FundId 
		and 
		fec.EntityType = 
			case
				when tpbf.FromFeedFg=1 and tpbf.FundTypeId <> 8 then ''Fund''
				when tpbf.FromFeedFg=1 and tpbf.FundTypeId = 8 then ''Equity''
				when tpbf.FromFeedFg=0 and tpbf.FundTypeId <> 8 then ''ManualFund''
				when tpbf.FromFeedFg=0 and tpbf.FundTypeId = 8 then ''ManualEquity''
			end	
		and fec.TenantId = ' + CAST(@tenantId as varchar(50)) + '
	left join fund2..Tcategory fc on fc.CategoryId=fec.CategoryId 
	left join fund2..TFundUnit fu on fu.FundUnitId = tpbf.FundId
	left join fund2..TEquity fe on fe.EquityId = tpbf.FundId
	left join policymanagement..TNonFeedFund nff on nff.NonFeedFundId = tpbf.FundId
where PB.IndigoClientId = ' + CAST(@tenantId as varchar(50)) + ' AND '

if @policyBusinessId > 0
	SET @sql = @sql + 'tpbf.policybusinessid = '+ Cast(@policyBusinessId as varchar(50))
else if len(@policyBusinessIds) > 0
	set @sql = @sql + 'tpbf.policybusinessid IN (' + @policyBusinessIds + ') '
else
	-- kill the query
	set @sql = @sql + '1 = 2 '

if (@filterCondition) = 'current'
 set @sql = @sql + ' and tpbf.CurrentUnitQuantity <> 0 '

-- Assets
set @sql = @sql + '
union all
select   
ta.PolicyBusinessId,          
ta.AssetsId as FundId,         
ta.AssetsId as PolicyBusinessFundId,         
ta.Description as FundName,        
null as FundTypeId,        
null as FromFeedFg,      
null as EquityFg,      
''Asset'' as Type,        
null as FundIndigoClientId,        
null as UnitQuantity,        
''N/A'' as FundCategory,
null as LastUnitChangeDate,         
isnull(policymanagement.dbo.FnConvertCurrency(ta.amount,ta.CurrencyCode, isnull(pb.BaseCurrency, '''')), 0) AS CurrentPrice,        
isnull(policymanagement.dbo.FnConvertCurrency(ta.amount,ta.CurrencyCode, isnull(pb.BaseCurrency, '''')), 0) AS TotalValue,        
isnull(convert(varchar(24),ta.valuedon,120), null) as LastPriceChangeDate,    
ta.PriceUpdatedByUser as PriceUpdatedByUser,      
ta.AssetCategoryId AS CategoryId,        
tac.SectorName AS CategoryName,  
policymanagement.dbo.FnConvertCurrency(ta.PurchasePrice,ta.CurrencyCode, isnull(pb.BaseCurrency, '''')) AS Cost,'  
+  
Cast(@tenantId as varchar(50)) + ' as TenantId,  
null as LastTransactionChangeDate,
null as RegularContributionPercentage,
pb.BaseCurrency as CurrencyCode,
null as APIRCode  
from 
	FactFind.dbo.tAssets ta
	JOIN CRM..TCRMContact C ON C.CRMContactId = ta.CRMContactId
	JOIN FactFind.dbo.TAssetCategory tac ON ta.AssetCategoryId = tac.AssetCategoryId
	JOIN TPolicyBusiness pb ON pb.PolicyBusinessId = ta.PolicyBusinessId       
where 
	C.IndClientId = ' + CAST(@tenantId as varchar(50)) + ' AND '

if @policyBusinessId > 0
	SET @sql = @sql + 'ta.policybusinessid = '+ Cast(@policyBusinessId as varchar(50))
else if len(@policyBusinessIds) > 0
	set @sql = @sql + 'ta.policybusinessid IN (' + @policyBusinessIds + ')'
else
	set @sql = @sql + '1 = 2 '

exec(@sql)
GO
