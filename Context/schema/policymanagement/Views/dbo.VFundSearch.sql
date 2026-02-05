SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE VIEW [dbo].[VFundSearch]
AS

SELECT
    fu.ComputedId									AS [Id],
    fu.FundUnitId                                   AS [FundId],
    NULL                                            AS [TenantId],
    CASE
		WHEN f.Source IS NULL THEN 'FinExFeed'
		ELSE f.Source
    END 									 		AS [Source],
    fu.UnitLongName                                 AS [Name],
    fu.UnitShortName                                AS [ShortName],
    fu.SedolCode                                    AS [SedolCode],
    fu.MexCode                                      AS [MexCode],
    fu.ISINCode                                     AS [ISINCode],
    fu.TickerCode                                   AS [EpicCode],
    fu.Citicode                                     AS [CitiCode],
    NULL                                            AS [ProviderCode],
    NULL                                            AS [Price],
    fup.MidPrice                                    AS [MidPrice],
    fup.BidPrice                                    AS [BidPrice],
    fup.OfferPrice                                  AS [OfferPrice],
    fup.PriceDate                                   AS [PriceDate],
    f.RefFundTypeId                                 AS [FundTypeId],
    f.FundSectorId                                  AS [FundSectorId],
    f.FundProviderId                                AS [FundProviderId],
    fu.IncAcc                                       AS [IncAcc],
    fu.InitialCharge                                AS [InitialCharge],
    fu.AnnualManagementCharge                       AS [AnnualMgmtCharge],
    fu.ExitCharge                                   AS [ExitCharge],
    fu.Yield                                        AS [Yield],
    CASE WHEN fu.UpdatedFg = 0 THEN 1 ELSE 0 END    AS [IsClosed],
    cr.Rate                                         AS [CurrencyRate],
    f.FundId                                        AS [BreakdownFundId],
    f.Objective                                     AS [Objective],
    f.LaunchDate                                    AS [LaunchDate],
    f.FundSize                                      AS [FundSize],
    f.FundSizeDate                                  AS [FundSizeDate],
    f.BenchmarkId                                   AS [BenchmarkId],
    fu.ExpenseRatio                                 AS [ExpenseRatio],
    f.CrownRating                                   AS [CrownRating],
    fup.DailyChange                                 AS [DailyChange],
    fup.YearHigh                                    AS [YearHigh],
    fup.YearLow                                     AS [YearLow],
    f.ManagerStartDate                              AS [ManagerStartDate],
    f.ManagerName                                   AS [ManagerName],
    f.ManagerBiography                              AS [ManagerBiography],
    f.FundManagerAlpha                              AS [FundManagerAlpha],
    fu.APIRCode                                     AS [APIRCode],
    fu.Currency                                     AS [Currency],
	fu.FeedFundCode                                 AS [FeedFundCode]
FROM Fund2..TFundUnit fu
INNER JOIN Fund2..TFund f on fu.FundId = f.FundId
INNER JOIN Fund2..TFundUnitPrice fup on fup.FundUnitId = fu.FundUnitId
LEFT JOIN Administration..TCurrencyRate cr on cr.IndigoClientId = 0
    and cr.CurrencyCode = fu.Currency

UNION ALL

SELECT
    nff.ComputedId									AS [Id],
    nff.NonFeedFundId                               AS [FundId],
    nff.IndigoClientId                              AS [TenantId],
    N'NonFeed'                                      AS [Source],
    nff.FundName                                    AS [Name],
    NULL                                            AS [ShortName],
    nff.Sedol                                       AS [SedolCode],
    nff.MexId                                       AS [MexCode],
    nff.ISIN                                        AS [ISINCode],
	nff.Epic										AS [EpicCode],
    nff.Citi                                        AS [CitiCode],
    nff.ProviderFundCode                            AS [ProviderCode],
    nff.CurrentPrice                                AS [Price],
    NULL                                            AS [MidPrice],
    NULL                                            AS [BidPrice],
    NULL                                            AS [OfferPrice],
    nff.PriceDate                                   AS [PriceDate],
    nff.FundTypeId                                  AS [FundTypeId],
    nff.CategoryId                                  AS [FundSectorId],
    nff.CompanyId                                   AS [FundProviderId],
    NULL                                            AS [IncAcc],
    NULL                                            AS [InitialCharge],
    NULL                                            AS [AnnualMgmtCharge],
    NULL                                            AS [ExitCharge],
    nff.IncomeYield                                 AS [Yield],
    nff.IsClosed                                    AS [IsClosed],
    NULL                                            AS [CurrencyRate],
    NULL                                            AS [BreakdownFundId],
    NULL                                            AS [Objective],
    NULL                                            AS [LaunchDate],
    NULL                                            AS [FundSize],
    NULL                                            AS [FundSizeDate],
    NULL                                            AS [BenchmarkId],
    NULL                                            AS [ExpenseRatio],
    NULL                                            AS [CrownRating],
    NULL                                            AS [DailyChange],
    NULL                                            AS [YearHigh],
    NULL                                            AS [YearLow],
    NULL                                            AS [ManagerStartDate],
    NULL                                            AS [ManagerName],
    NULL                                            AS [ManagerBiography],
    NULL                                            AS [FundManagerAlpha],
    NULL                                            AS [APIRCode],
    ref.CurrencyCode                                AS [Currency],
	NULL                                            AS [FeedFundCode]
FROM 
	TNonFeedFund nff
	JOIN administration..TRefRegionalCurrency ref 
	ON RegionalCurrencyId = 0

UNION ALL

SELECT
	ed.ComputedId									AS [Id],
	ed.EquityId										AS [FundId],
	NULL											AS [TenantId],
	'Equity'										AS [Source],
	ed.Name											AS [Name],
	null											AS [ShortName],
	NULL											AS [SedolCode],
	NULL											AS [MexCode],
	ed.IsinCode										AS [IsinCode],
	ed.EpicCode										AS [EpicCode],
	NULL											AS [CitiCode],
	NULL											AS [ProviderCode],
	epd.Price										AS [Price],
	ep.Mid											as [MidPrice],
	ep.Bid											as [BidPrice],
	ep.Ask											as [OfferPrice],
	epd.PriceDate									AS [PriceDate],
	8												AS [FundTypeId],
    null											AS [FundSectorId],
    null											AS [FundProviderId],
    NULL                                            AS [IncAcc],
    NULL                                            AS [InitialCharge],
    NULL                                            AS [AnnualMgmtCharge],
    NULL                                            AS [ExitCharge],
	null											AS [Yield],
    CASE WHEN ed.UpdatedFg = 0 THEN 1 ELSE 0 END    AS [IsClosed],
    NULL                                            AS [CurrencyRate],
    NULL                                            AS [BreakdownFundId],
    NULL                                            AS [Objective],
    NULL                                            AS [LaunchDate],
    NULL                                            AS [FundSize],
    NULL                                            AS [FundSizeDate],
    e.BenchmarkId                                   AS [BenchmarkId],
    NULL                                            AS [ExpenseRatio],
    NULL                                            AS [CrownRating],
    NULL                                            AS [DailyChange],
    ep.YearHigh                                     AS [YearHigh],
    ep.YearLow                                      AS [YearLow],
    NULL                                            AS [ManagerStartDate],
    NULL                                            AS [ManagerName],
    NULL                                            AS [ManagerBiography],
    NULL                                            AS [FundManagerAlpha],
    NULL                                            AS [APIRCode],
    ed.Currency                                     AS [Currency],
	NULL                                            AS [FeedFundCode]
FROM TEquityDenorm ed    
LEFT JOIN TEquityPriceDenorm epd ON ed.EquityId = epd.EquityId    
left join fund2..TEquityPrice ep on ep.EquityId = ed.EquityId
left join fund2..TEquity e on e.EquityId = epd.EquityId

GO