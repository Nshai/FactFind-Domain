CREATE TABLE [dbo].[TTransactionReportDeclarationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[Declaration] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[TransactionReportDeclarationId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TTransactionReportDeclarationAudit] ADD CONSTRAINT [PK_TTransactionReportDeclarationAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
