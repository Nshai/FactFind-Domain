CREATE TABLE [dbo].[TAssetTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AssetTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAssetType_ConcurrencyId_1__56] DEFAULT ((1)),
[AssetTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAssetType_StampDateTime_2__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAssetTypeAudit] ADD CONSTRAINT [PK_TAssetTypeAudit_3__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TAssetTypeAudit_AssetTypeId_ConcurrencyId] ON [dbo].[TAssetTypeAudit] ([AssetTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
