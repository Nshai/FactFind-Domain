CREATE TABLE [dbo].[TAsset]
(
[AssetId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[AssetName] [varchar] (255)  NOT NULL,
[AssetQuantity] [int] NOT NULL CONSTRAINT [DF_TAsset_AssetQuantity] DEFAULT ((1)),
[Valuation] [money] NOT NULL CONSTRAINT [DF_TAsset_Valuation] DEFAULT ((0)),
[ValuationDate] [datetime] NULL,
[AssetTypeId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAsset_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAsset] ADD CONSTRAINT [PK_TAsset] PRIMARY KEY NONCLUSTERED  ([AssetId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAsset_AssetTypeId] ON [dbo].[TAsset] ([AssetTypeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TAsset_CRMContactId] ON [dbo].[TAsset] ([CRMContactId])
GO
ALTER TABLE [dbo].[TAsset] ADD CONSTRAINT [FK_TAsset_AssetTypeId_AssetTypeId] FOREIGN KEY ([AssetTypeId]) REFERENCES [dbo].[TAssetType] ([AssetTypeId])
GO
ALTER TABLE [dbo].[TAsset] WITH CHECK ADD CONSTRAINT [FK_TAsset_CRMContactId_CRMContactId] FOREIGN KEY ([CRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
