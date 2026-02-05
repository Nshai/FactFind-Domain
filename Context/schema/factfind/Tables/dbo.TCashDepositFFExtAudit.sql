CREATE TABLE [dbo].[TCashDepositFFExtAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[NonDisclosure] [bit] NULL,
[ExistingCashDepositAccounts] [bit] NULL,
[ConcurrencyId] [int] NOT NULL,
[CashDepositFFExtId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TCashDepositFFExtAudit] ADD CONSTRAINT [PK_TCashDepositFFExtAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
