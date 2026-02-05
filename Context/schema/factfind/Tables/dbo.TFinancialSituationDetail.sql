CREATE TABLE [dbo].[TFinancialSituationDetail]
(
[FinancialSituationDetailId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Year] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Turnover] [money] NULL,
[GrossProfit] [money] NULL,
[NetProfitBeforeTax] [money] NULL,
[TaxBill] [money] NULL,
[PAT] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TFinancia__Concu__5CE1B823] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TFinancialSituationDetail_CRMContactId] ON [dbo].[TFinancialSituationDetail] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
