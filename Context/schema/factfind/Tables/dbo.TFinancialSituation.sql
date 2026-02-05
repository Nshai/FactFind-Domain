CREATE TABLE [dbo].[TFinancialSituation]
(
[FinancialSituationId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[DateEstablished] [datetime] NULL,
[FinancialYearEnd] [datetime] NULL,
[ApproxValue] [money] NULL,
[TotalInvestmentAssetValue] [money] NULL,
[TotalCollateralValue] [money] NULL,
[ValueIncreasingYesNo] [bit] NULL,
[Rate] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TFinancia__Concu__5AF96FB1] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TFinancialSituation_CRMContactId] ON [dbo].[TFinancialSituation] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
