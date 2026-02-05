CREATE TABLE [dbo].[TAssetTypeIdAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AssetTypeId] [int] NOT NULL,
[AssetTypeName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAssetType_ConcurrencyId_1__73] DEFAULT ((1)),
[AssetTypeIdId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAssetType_StampDateTime_2__73] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAssetTypeIdAudit] ADD CONSTRAINT [PK_TAssetTypeIdAudit_3__73] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TAssetTypeIdAudit_AssetTypeIdId_ConcurrencyId] ON [dbo].[TAssetTypeIdAudit] ([AssetTypeIdId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
