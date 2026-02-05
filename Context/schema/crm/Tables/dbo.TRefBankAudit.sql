CREATE TABLE [dbo].[TRefBankAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefBankAudit_ConcurrencyId] DEFAULT ((1)),
[RefBankId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefBankAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefBankAudit] ADD CONSTRAINT [PK_TRefBankAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRefBankAudit_RefBankId_ConcurrencyId] ON [dbo].[TRefBankAudit] ([RefBankId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
