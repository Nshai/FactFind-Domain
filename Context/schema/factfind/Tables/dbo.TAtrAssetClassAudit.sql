CREATE TABLE [dbo].[TAtrAssetClassAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Allocation] [decimal] (5, 2) NULL,
[Ordering] [tinyint] NULL,
[AtrRefAssetClassId] [int] NULL,
[AtrPortfolioGuid] [uniqueidentifier] NULL,
[Guid] [uniqueidentifier] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrAssetClassAudit_ConcurrencyId] DEFAULT ((1)),
[AtrAssetClassId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrAssetClassAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrAssetClassAudit] ADD CONSTRAINT [PK_TAtrAssetClassAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrAssetClassAudit_AtrAssetClassId_ConcurrencyId] ON [dbo].[TAtrAssetClassAudit] ([AtrAssetClassId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
