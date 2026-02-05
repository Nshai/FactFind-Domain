CREATE TABLE [dbo].[TAtrAssetClassCombinedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AtrAssetClassId] [int] NOT NULL,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Allocation] [decimal] (5, 2) NULL,
[Ordering] [tinyint] NULL,
[AtrRefAssetClassId] [int] NULL,
[AtrPortfolioGuid] [uniqueidentifier] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrAssetClassCombinedAudit_ConcurrencyId] DEFAULT ((1)),
[Guid] [uniqueidentifier] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrAssetClassCombinedAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrAssetClassCombinedAudit] ADD CONSTRAINT [PK_TAtrAssetClassCombinedAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrAssetClassCombinedAudit_Guid_ConcurrencyId] ON [dbo].[TAtrAssetClassCombinedAudit] ([Guid], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
