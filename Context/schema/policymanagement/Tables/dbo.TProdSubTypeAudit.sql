CREATE TABLE [dbo].[TProdSubTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[QuoteProductId] [int] NULL,
[NBProductId] [int] NULL,
[OrigoTableName] [varchar] (255) NULL,
[ProdSubTypeName] [varchar] (255) NULL,
[QuoteSubRef] [varchar] (255) NULL,
[NBSubRef] [varchar] (255) NULL,
[ClientSummary] [varchar] (2000) NULL,
[ProductSummary] [varchar] (2000) NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[ProdSubTypeId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TProdSubTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TProdSubTypeAudit] ADD CONSTRAINT [PK_TProdSubTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_Audit_TProdSubTypeAudit_ProdSubTypeId_ConcurrencyId] ON [dbo].[TProdSubTypeAudit] ([ProdSubTypeId], [ConcurrencyId])
GO
