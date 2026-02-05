CREATE TABLE [dbo].[TRefAssetClassAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AssetClassName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[FundsDBName] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RetireFg] [tinyint] NULL,
[FundsAllowedFg] [tinyint] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[RefAssetClassId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefAssetC_StampDateTime_1__77] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefAssetClassAudit] ADD CONSTRAINT [PK_TRefAssetClassAudit_2__77] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TRefAssetClassAudit_RefAssetClassId_ConcurrencyId] ON [dbo].[TRefAssetClassAudit] ([RefAssetClassId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
