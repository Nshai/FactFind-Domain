CREATE TABLE [dbo].[TAssetAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NULL,
[AssetName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[AssetQuantity] [int] NOT NULL CONSTRAINT [DF_TAssetAudi_AssetQuantity_1__56] DEFAULT ((1)),
[Valuation] [money] NOT NULL CONSTRAINT [DF_TAssetAudi_Valuation_4__56] DEFAULT ((0)),
[ValuationDate] [datetime] NULL,
[AssetTypeId] [int] NOT NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAssetAudi_ConcurrencyId_2__56] DEFAULT ((1)),
[AssetId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAssetAudi_StampDateTime_3__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAssetAudit] ADD CONSTRAINT [PK_TAssetAudit_5__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TAssetAudit_AssetId_ConcurrencyId] ON [dbo].[TAssetAudit] ([AssetId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
