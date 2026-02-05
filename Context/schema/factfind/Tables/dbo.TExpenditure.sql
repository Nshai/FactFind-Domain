CREATE TABLE [dbo].[TExpenditure]
(
[ExpenditureId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TExpenditure_ConcurrencyId] DEFAULT ((1)),
[CRMContactId] [int] NOT NULL,
[IsDetailed] [bit] NULL,
[NetMonthlySummaryAmount] [money] NULL,
[IsChangeExpected] [bit] NULL,
[IsRiseExpected] [bit] NULL,
[ChangeAmount] [money] NULL,
[ChangeReason] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[HasFactFindLiabilitiesImported] [bit] NULL
)
GO
ALTER TABLE [dbo].[TExpenditure] ADD CONSTRAINT [PK_TExpenditure] PRIMARY KEY NONCLUSTERED  ([ExpenditureId])
GO
CREATE NONCLUSTERED INDEX [IDX_TExpenditure_CRMContactId] ON [dbo].[TExpenditure] ([CRMContactId])
GO
