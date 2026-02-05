CREATE TABLE [dbo].[TPortfolioFundAssetChartData]
(
[PortfolioFundAssetChartDataId] [int] NOT NULL IDENTITY(1, 1),
[PortfolioId] [int] NOT NULL,
[AssetXMLData] [varchar] (8000) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPortfolioFundAssetChartData_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPortfolioFundAssetChartData] ADD CONSTRAINT [PK_TPortfolioFundAssetChartData] PRIMARY KEY NONCLUSTERED  ([PortfolioFundAssetChartDataId])
GO
