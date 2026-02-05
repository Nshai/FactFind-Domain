CREATE TABLE [dbo].[TFinancialPlanningSelectedInvestments]
(
[FinancialPlanningSelectedInvestmentsId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[InvestmentId] [int] NOT NULL,
[InvestmentType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningSelectedInvestments_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TFinancialPlanningSelectedInvestments] ADD CONSTRAINT [PK_TFinancialPlanningSelectedInvestments] PRIMARY KEY NONCLUSTERED  ([FinancialPlanningSelectedInvestmentsId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFinancialPlanningSelectedInvestments_financialplanningid] ON [dbo].[TFinancialPlanningSelectedInvestments] ([FinancialPlanningId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFinancialPlanningSelectedInvestments_InvestmentId] ON [dbo].[TFinancialPlanningSelectedInvestments] ([InvestmentId])
GO
