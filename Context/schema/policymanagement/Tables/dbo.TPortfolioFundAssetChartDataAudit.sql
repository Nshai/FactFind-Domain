CREATE TABLE [dbo].[TPortfolioFundAssetChartDataAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PortfolioId] [int] NOT NULL,
[AssetXMLData] [varchar] (8000) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPortfolioFundAssetChartDataAudit_ConcurrencyId] DEFAULT ((1)),
[PortfolioFundAssetChartDataId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPortfolioFundAssetChartDataAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPortfolioFundAssetChartDataAudit] ADD CONSTRAINT [PK_TPortfolioFundAssetChartDataAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPortfolioFundAssetChartDataAudit_PortfolioFundAssetChartDataId_ConcurrencyId] ON [dbo].[TPortfolioFundAssetChartDataAudit] ([PortfolioFundAssetChartDataId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
