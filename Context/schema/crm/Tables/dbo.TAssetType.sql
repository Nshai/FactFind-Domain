CREATE TABLE [dbo].[TAssetType]
(
[AssetTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[AssetTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAssetTypeId_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAssetType] ADD CONSTRAINT [PK_TAssetTypeId] PRIMARY KEY NONCLUSTERED  ([AssetTypeId]) WITH (FILLFACTOR=80)
GO
