CREATE TABLE [dbo].[TProductTermAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[TermType] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Value] [int] NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[ProductTermId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TProductTermAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TProductTermAudit] ADD CONSTRAINT [PK_TProductTermAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
