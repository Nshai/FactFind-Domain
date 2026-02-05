CREATE TABLE [dbo].[TFinancialPlanningScenario2Investment]
(
[FinancialPlanningScenario2InvestmentId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningScenarioId] [int] NOT NULL,
[InvestmentId] [int] NOT NULL,
[InvestmentType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningScenario2Investment_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFinancialPlanningScenario2Investment] ADD CONSTRAINT [PK_TFinancialPlanningScenario2Investment] PRIMARY KEY NONCLUSTERED  ([FinancialPlanningScenario2InvestmentId])
GO
