CREATE TABLE [dbo].[TIncome]
(
[IncomeId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIncome_ConcurrencyId] DEFAULT ((1)),
[CRMContactId] [int] NOT NULL,
[IsChangeExpected] [bit] NULL,
[IsRiseExpected] [bit] NULL,
[ChangeAmount] [money] NULL,
[ChangeReason] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TIncome] ADD CONSTRAINT [PK_TIncome] PRIMARY KEY NONCLUSTERED  ([IncomeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TIncome_CRMContactId] ON [dbo].[TIncome] ([CRMContactId])
GO
