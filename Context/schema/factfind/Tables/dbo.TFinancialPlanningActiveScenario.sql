CREATE TABLE [dbo].[TFinancialPlanningActiveScenario]
(
[FinancialPlanningActiveScenarioId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[FinancialPlanningScenarioId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningActiveScenario_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFinancialPlanningActiveScenario] ADD CONSTRAINT [PK_TFinancialPlanningActiveScenario] PRIMARY KEY NONCLUSTERED  ([FinancialPlanningActiveScenarioId])
GO
