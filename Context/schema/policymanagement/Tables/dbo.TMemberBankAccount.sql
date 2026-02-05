CREATE TABLE [dbo].[TMemberBankAccount]
(
[MemberBankAccountId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[BankAccountName] [varchar] (40) COLLATE Latin1_General_CI_AS NULL,
[BankAccountValue] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMemberBankAccount_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TMemberBankAccount] ADD CONSTRAINT [PK_TMemberBankAccount] PRIMARY KEY CLUSTERED  ([MemberBankAccountId])
GO
