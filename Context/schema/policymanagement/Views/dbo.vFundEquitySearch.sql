SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[vFundEquitySearch]
AS

SELECT 
	fd.ComputedId                               AS [Id],
	fd.FundUnitId								AS [FundUnitId],
	NULL										AS [TenantId],
	'FeedFund'									AS [Type],
	fd.Name										AS [Name],
	fd.SedolCode								AS [SedolCode],
	fd.MexCode									AS [MexCode],
	fd.ISINCode									AS [ISINCode],
	fd.TickerCode								AS [EpicCode],
	fd.Citicode									AS [CitiCode],
	NULL										AS [ProviderCode],
	fpd.Price									AS [Price],
	fpd.PriceDate								AS [PriceDate],
	fd.FundTypeId								AS [FundTypeId],
	fd.FundTypeName								AS [FundTypeName],
	fd.FundSectorId								AS [CategoryId],
	fd.FundSectorName							AS [CategoryName],
	CASE WHEN fd.UpdatedFg = 0 THEN 1 ELSE 0 END	AS [IsClosed],
	fd.Currency									AS [Currency],
	fd.APIRCode									AS [APIRCode],
	fd.Source									AS [Source],
	fd.FeedFundCode								AS [FeedFundCode]
FROM TFundDenorm fd LEFT JOIN TFundPriceDenorm fpd ON fd.FundUnitId = fpd.FundUnitId

UNION ALL

SELECT
	ed.ComputedId								AS [Id],
	ed.EquityId									AS [FundUnitId],
	NULL										AS [TenantId],
	'Equity'									AS [Type],
	ed.Name										AS [Name],
	NULL										AS [SedolCode],
	NULL										AS [MexCode],
	ed.IsinCode									AS [IsinCode],
	ed.EpicCode									AS [EpicCode],
	NULL										AS [CitiCode],
	NULL										AS [ProviderCode],
	epd.Price									AS [Price],
	epd.PriceDate								AS [PriceDate],
	8											AS [FundTypeId],
	'Equities'									AS [FundTypeName],
	NULL										AS [CategoryId],
	'Equity'									AS [CategoryName],
	CASE WHEN ed.UpdatedFg = 0 THEN 1 ELSE 0 END	AS [IsClosed],
	ed.Currency									AS [Currency],
	NULL										AS [APIRCode],
	NULL										AS [Source],
	NULL										AS [FeedFundCode]
FROM TEquityDenorm ed    
LEFT JOIN TEquityPriceDenorm epd ON ed.EquityId = epd.EquityId

UNION ALL

SELECT 
	nff.ComputedId								AS [Id],
	nff.NonFeedFundId							AS [FundUnitId],
	nff.IndigoClientId							AS [TenantId],
	'ManualFund'								AS [Type],
	nff.FundName								AS [FundName],
	nff.Sedol									AS [SedolCode],
	nff.MexId									AS [MexCode],
	nff.ISIN									AS [ISIN],
	NULL										AS [EpicCode],
	nff.Citi									AS [CitiCode],
	nff.ProviderFundCode						AS [ProviderCode],
	nff.CurrentPrice							AS [Price],
	nff.PriceDate								AS [PriceDate],
	nff.FundTypeId								AS [FundTypeId],
	nff.FundTypeName							AS [FundTypeName],
	nff.CategoryId								AS [CategoryId],
	nff.CategoryName							AS [CategoryName],
	nff.IsClosed								AS [IsClosed],
	ISNULL(ref.CurrencyCode,'GBP')				AS [Currency],
	NULL										AS [APIRCode],
	NULL										AS [Source],
	NULL										AS [FeedFundCode]
FROM 
	TNonFeedFund nff
	LEFT JOIN administration.dbo.TRefRegionalCurrency ref on ref.RegionalCurrencyId = 0

GO