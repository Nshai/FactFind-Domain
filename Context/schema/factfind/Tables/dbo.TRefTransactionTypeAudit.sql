CREATE TABLE [dbo].[TRefTransactionTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[TransactionType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NULL,
[RefTransactionTypeId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (225) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefTransactionTypeAudit] ADD CONSTRAINT [PK_TRefTransactionTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
