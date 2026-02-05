CREATE TABLE [dbo].[TAssetCategory]
(
[AssetCategoryId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CategoryName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[SectorName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAssetCategory_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAssetCategory] ADD CONSTRAINT [PK_TAssetCategory] PRIMARY KEY NONCLUSTERED  ([AssetCategoryId]) WITH (FILLFACTOR=80)
GO
