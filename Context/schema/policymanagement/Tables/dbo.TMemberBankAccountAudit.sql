CREATE TABLE [dbo].[TMemberBankAccountAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[BankAccountName] [varchar] (40) COLLATE Latin1_General_CI_AS NULL,
[BankAccountValue] [money] NULL,
[ConcurrencyId] [int] NULL,
[MemberBankAccountId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TMemberBankAccountAudit] ADD CONSTRAINT [PK_TMemberBankAccountAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
