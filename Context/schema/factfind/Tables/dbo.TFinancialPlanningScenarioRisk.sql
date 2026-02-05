CREATE TABLE [dbo].[TFinancialPlanningScenarioRisk]
(
[FinancialPlanningScenarioRiskId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NULL,
[ScenarioId] [int] NULL,
[RiskDescription] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RiskNumber] [int] NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningScenarioRisk] ADD CONSTRAINT [PK_TFinancialPlanningScenarioRisk] PRIMARY KEY NONCLUSTERED  ([FinancialPlanningScenarioRiskId])
GO
