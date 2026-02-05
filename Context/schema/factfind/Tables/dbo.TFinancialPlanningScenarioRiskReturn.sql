CREATE TABLE [dbo].[TFinancialPlanningScenarioRiskReturn]
(
[FinancialPlanningScenarioRiskReturnId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningScenarioId] [int] NOT NULL,
[AverageAnnualReturn] [decimal] (18, 9) NOT NULL,
[AverageVolatilityReturn] [decimal] (18, 9) NOT NULL,
[FinancialPlanningId] [int] NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningScenarioRiskReturn] ADD CONSTRAINT [PK_TFinancialPlanningScenarioRiskReturn] PRIMARY KEY CLUSTERED  ([FinancialPlanningScenarioRiskReturnId])
GO
