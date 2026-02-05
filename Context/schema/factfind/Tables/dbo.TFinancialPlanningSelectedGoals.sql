CREATE TABLE [dbo].[TFinancialPlanningSelectedGoals]
(
[FinancialPlanningSelectedGoalsId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[ObjectiveId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningSelectedGoals_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TFinancialPlanningSelectedGoals] ADD CONSTRAINT [PK_TFinancialPlanningSelectedGoals] PRIMARY KEY NONCLUSTERED  ([FinancialPlanningSelectedGoalsId])
GO
CREATE NONCLUSTERED INDEX IX_TFinancialPlanningSelectedGoals_FinancialPlanningId ON [dbo].[TFinancialPlanningSelectedGoals] ([FinancialPlanningId])
GO