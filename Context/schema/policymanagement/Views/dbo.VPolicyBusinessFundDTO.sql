SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VPolicyBusinessFundDTO]
AS
SELECT	tpbf.FundId, 
		tpbf.PolicyBusinessFundId, 
		tpbf.FundName, 
		tpbf.FundTypeId, 
		tpbf.FromFeedFg AS isFromFeed, 
		tpbf.EquityFg AS isEquity, 
        CASE WHEN tpbf.FundTypeId <> 8 THEN 'Fund' WHEN tpbf.FundTypeId = 8 THEN 'Equity' END AS HoldingType, 
        ISNULL(tpbf.FundIndigoClientId, 0) AS FundIndigoClientId, 
        ISNULL(ROUND(SUM(tpbft.UnitQuantity), 4), 0) AS UnitQuantity, 
		fc.Name FundCategory,
        ISNULL(CONVERT(varchar(24), tpbf.LastUnitChangeDate, 120), NULL) AS LastUnitChangeDate, 
        ISNULL(ROUND(tpbf.CurrentPrice, 4), 0) AS CurrentPrice, 
		ISNULL(ROUND(tpbf.CurrentPrice * SUM(tpbft.UnitQuantity), 4), 0) AS TotalValue, 
		ISNULL(CONVERT(varchar(24), tpbf.LastPriceChangeDate, 120), NULL) AS LastPriceChangeDate, 
		tpbf.CategoryId, tpbf.CategoryName, 
		tpbf.Cost,
		tpbf.PolicyBusinessId,
		tpbf.PriceUpdatedByUser,
		tpb.IndigoClientId as TenantId,
		ISNULL(CONVERT(varchar(24), tpbf.LastTransactionChangeDate, 120), NULL) AS LastTransactionChangeDate,
		tpbf.RegularContributionPercentage,
		tpb.BaseCurrency as CurrencyCode,
        IIF(tpbf.EquityFg = 1, fe.EpicCode, IIF(tpbf.FromFeedFg=1, fu.APIRCode, nff.ProviderFundCode)) as ApirCode
FROM    dbo.TPolicyBusinessFund AS tpbf 
	JOIN TPolicyBusiness tpb ON tpbf.PolicyBusinessId=tpb.PolicyBusinessId
	LEFT JOIN fund2..Tentitycategory fec on fec.entityID = tpbf.FundId 
		and 
		fec.EntityType = 
			case
				when tpbf.FromFeedFg=1 and tpbf.FundTypeId <> 8 then 'Fund'
				when tpbf.FromFeedFg=1 and tpbf.FundTypeId = 8 then 'Equity'
				when tpbf.FromFeedFg=0 and tpbf.FundTypeId <> 8 then 'ManualFund'
				when tpbf.FromFeedFg=0 and tpbf.FundTypeId = 8 then 'ManualEquity'
			end	
		and fec.TenantId = tpb.IndigoClientId
	LEFT JOIN fund2..Tcategory fc on fc.CategoryId=fec.CategoryId
    LEFT JOIN fund2..TFundUnit fu on fu.FundUnitId = tpbf.FundId
    LEFT JOIN fund2..TEquity fe on fe.EquityId = tpbf.FundId
	LEFT JOIN policymanagement..TNonFeedFund nff on nff.NonFeedFundId = tpbf.FundId
	LEFT OUTER JOIN dbo.TPolicyBusinessFundTransaction AS tpbft 
	ON tpbft.TenantId = tpbf.FundIndigoClientId
	AND tpbft.PolicyBusinessFundId = tpbf.PolicyBusinessFundId
GROUP BY tpbf.PolicyBusinessFundId, tpbf.FundId, tpbf.FundName, tpbf.FundTypeId, tpbf.FromFeedFg, tpbf.EquityFg, tpbf.FundIndigoClientId, 
		tpbf.LastUnitChangeDate, tpbf.CurrentPrice, tpbf.LastPriceChangeDate, tpbf.CategoryId, tpbf.CategoryName, tpbf.PolicyBusinessId, 
		tpbf.Cost,tpbf.PriceUpdatedByUser,tpb.IndigoClientId,tpbf.LastTransactionChangeDate, tpbf.RegularContributionPercentage,fc.Name,
		tpb.BaseCurrency, fu.APIRCode, fe.EpicCode, nff.NonFeedFundId, nff.ProviderFundCode
UNION ALL
SELECT  ta.AssetsId AS FundId, 
		ta.AssetsId AS PolicyBusinessFundId, 
		ta.Description AS FundName, 
		NULL AS FundTypeId, 
		NULL AS FromFeedFg, 
		NULL AS EquityFg, 
		'Asset' AS Type, 
		NULL AS FundIndigoClientId, 
		NULL AS UnitQuantity, 
		'N/A' as FundCategory,		
		NULL AS LastUnitChangeDate, 
		ISNULL(ta.Amount, 0) AS CurrentPrice,
        ISNULL(ta.Amount, 0) AS TotalValue, 
        ISNULL(CONVERT(varchar(24), ta.ValuedOn, 120), NULL) AS LastPriceChangeDate, 
		ta.AssetCategoryId AS CategoryId, 
		tac.SectorName AS CategoryName, 
		ta.PurchasePrice AS Cost,
		ta.PolicyBusinessId AS PolicyBusinessId,
		ta.PriceUpdatedByUser,
		tac.IndigoClientId as TenantId,
		NULL AS LastTransactionChangeDate,
		NULL AS RegularContributionPercentage,
		tpb.BaseCurrency AS CurrencyCode,
		NULL AS ApirCode
FROM    FactFind.dbo.TAssets AS ta INNER JOIN
        FactFind.dbo.TAssetCategory AS tac ON ta.AssetCategoryId = tac.AssetCategoryId
		LEFT JOIN TPolicyBusiness tpb ON ta.PolicyBusinessId = tpb.PolicyBusinessId
GO
