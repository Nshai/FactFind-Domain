CREATE TABLE [dbo].[TFundAssetSummary]
(
[FundAssetSummaryId] [int] NOT NULL IDENTITY(1, 1),
[EquityId] [int] NULL,
[FundId] [int] NULL,
[UpdatedByUserId] [int] NOT NULL,
[UpdatedOn] [datetime] NOT NULL CONSTRAINT [DF_TFundAssetSummary_UpdatedOn] DEFAULT (getdate()),
[TenantId] [int] NOT NULL,
[IsEquity] [bit] NOT NULL,
[IsFromFeed] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFundAssetSummary_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFundAssetSummary] ADD CONSTRAINT [PK_TFundAssetSummary] PRIMARY KEY CLUSTERED  ([FundAssetSummaryId])
GO
