CREATE TABLE [dbo].[TAssetValuationHistory]
(
[AssetValuationHistoryId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAssetValuationHistory_ConcurrencyId] DEFAULT ((1)),
[AssetId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[Valuation] [money] NOT NULL,
[ValuationDate] [datetime] NOT NULL,
[ValueUpdatedByUserId] [int] NULL
)
GO
ALTER TABLE [dbo].[TAssetValuationHistory] ADD CONSTRAINT [PK_TAssetValuationHistory] PRIMARY KEY NONCLUSTERED  ([AssetValuationHistoryId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IX_TAssetValuationHistory_AssetId] ON [dbo].[TAssetValuationHistory] ([AssetId])
GO
CREATE NONCLUSTERED INDEX [IX_TAssetValuationHistory_ValuationDate] ON [dbo].[TAssetValuationHistory]([ValuationDate] ASC)
GO