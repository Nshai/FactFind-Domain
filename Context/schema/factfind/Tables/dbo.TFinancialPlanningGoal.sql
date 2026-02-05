CREATE TABLE [dbo].[TFinancialPlanningGoal]
(
[FinancialPlanningGoalId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[ObjectiveId] [int] NOT NULL,
[Objective] [varchar] (500) COLLATE Latin1_General_CI_AS NULL,
[TargetAmount] [money] NULL,
[StartDate] [datetime] NULL,
[TargetDate] [datetime] NULL,
[RiskProfileGuid] [uniqueidentifier] NULL,
[ObjectiveTypeId] [int] NULL,
[RefGoalCategoryId] [int] NULL,
[CRMContactId] [int] NULL,
[CRMContactId2] [int] NULL,
[FinancialPlanningSessionId] [int] NULL,
[RiskProfileId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningGoal_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFinancialPlanningGoal] ADD CONSTRAINT [PK_TFinancialPlanningGoal] PRIMARY KEY NONCLUSTERED  ([FinancialPlanningGoalId])
GO
ALTER TABLE [dbo].[TFinancialPlanningGoal] ADD CONSTRAINT [FK_TFinancialPlanningGoal_ObjectiveTypeId_TFinancialPlanningGoalType] FOREIGN KEY ([ObjectiveTypeId]) REFERENCES [dbo].[TObjectiveType] ([ObjectiveTypeId])
GO
CREATE NONCLUSTERED INDEX [IX_TFinancialPlanningGoal_FinancialPlanningSessionId] ON [dbo].[TFinancialPlanningGoal] ([FinancialPlanningSessionId]) INCLUDE ([FinancialPlanningGoalId])
GO