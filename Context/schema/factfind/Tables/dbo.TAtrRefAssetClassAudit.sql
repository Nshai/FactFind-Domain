CREATE TABLE [dbo].[TAtrRefAssetClassAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ShortName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Ordering] [tinyint] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrRefAssetClassAudit_ConcurrencyId] DEFAULT ((1)),
[AtrRefAssetClassId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrRefAssetClassAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrRefAssetClassAudit] ADD CONSTRAINT [PK_TAtrRefAssetClassAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrRefAssetClassAudit_AtrRefAssetClassId_ConcurrencyId] ON [dbo].[TAtrRefAssetClassAudit] ([AtrRefAssetClassId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
