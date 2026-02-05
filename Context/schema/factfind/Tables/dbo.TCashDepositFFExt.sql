CREATE TABLE [dbo].[TCashDepositFFExt]
(
[CashDepositFFExtId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[NonDisclosure] [bit] NULL,
[ExistingCashDepositAccounts] [bit] NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
CREATE NONCLUSTERED INDEX [IDX_TCashDepositFFExt_CRMContactId] ON [dbo].[TCashDepositFFExt] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
