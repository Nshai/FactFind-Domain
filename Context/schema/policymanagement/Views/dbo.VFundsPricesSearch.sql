USE [policymanagement]
GO

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE VIEW [dbo].[VFundsPricesSearch]
AS

SELECT
    fuph.Price                                      AS [Price],
    fuph.PriceDate                                  AS [PriceDate],
    ('F' + CONVERT(varchar(10), fu.FundUnitId))     AS [FundId],
    NULL                                            AS [TenantId],
    fu.UnitLongName                                 AS [FundName],
    fu.SedolCode                                    AS [SedolCode],
    fu.MexCode                                      AS [MexCode],
    fu.ISINCode                                     AS [ISINCode],
    fu.Citicode                                     AS [CitiCode],
    NULL                                            AS [ProviderCode]
FROM fund2..TFundUnitPriceHistory fuph
INNER JOIN Fund2..TFundUnit fu on fu.FundUnitId = fuph.FundUnitId
INNER JOIN Fund2..TFund f on fu.FundId = f.FundId

UNION ALL

SELECT
    nffph.Price                                     AS [Price],
    nffph.PriceDate                                 AS [PriceDate],
    ('M' + CONVERT(varchar(10), nff.NonFeedFundId)) AS [FundId],
    nff.IndigoClientId                              AS [TenantId],
    nff.FundName                                    AS [FundName],
    nff.Sedol                                       AS [SedolCode],
    nff.MexId                                       AS [MexCode],
    nff.ISIN                                        AS [ISINCode],
    nff.Citi                                        AS [CitiCode],
    nff.ProviderFundCode                            AS [ProviderCode]
FROM policymanagement..TNonFeedFundPriceHistory nffph
INNER JOIN  TNonFeedFund nff on nff.NonFeedFundId = nffph.NonFeedFundId


GO


