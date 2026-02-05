CREATE TABLE [dbo].[TDebt]
(
[DebtId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[ChargesYN] [bit] NULL,
[ChargesDetails] [varchar] (1536) COLLATE Latin1_General_CI_AS NULL,
[ComfortExtracCash] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TDebt__Concurren__0CC5D56F] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TDebt_CRMContactId] ON [dbo].[TDebt] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
