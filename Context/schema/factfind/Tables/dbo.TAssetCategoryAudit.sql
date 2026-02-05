CREATE TABLE [dbo].[TAssetCategoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CategoryName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[SectorName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAssetCategoryAudit_ConcurrencyId] DEFAULT ((1)),
[AssetCategoryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAssetCategoryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAssetCategoryAudit] ADD CONSTRAINT [PK_TAssetCategoryAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAssetCategoryAudit_AssetCategoryId_ConcurrencyId] ON [dbo].[TAssetCategoryAudit] ([AssetCategoryId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
