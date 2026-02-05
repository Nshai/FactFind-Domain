CREATE TABLE [dbo].[TFinancialPlanningSelectedFunds]
(
[FinancialPlanningSelectedFundsId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningSelectedInvestmentsId] [int] NOT NULL,
[PolicyBusinessFundId] [int] NOT NULL,
[IsAsset] [bit] NULL CONSTRAINT [DF_TFinancialPlanningSelectedFunds_IsAsset] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningSelectedFunds_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TFinancialPlanningSelectedFunds] ADD CONSTRAINT [PK_TFinancialPlanningSelectedFunds] PRIMARY KEY NONCLUSTERED  ([FinancialPlanningSelectedFundsId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFinancialPlanningSelectedFunds_FinancialPlanningSelectedInvestmentsId] ON [dbo].[TFinancialPlanningSelectedFunds] ([FinancialPlanningSelectedInvestmentsId])
GO
