CREATE TABLE [dbo].[TEvalueGoal]
(
[EvalueGoalId] [int] NOT NULL IDENTITY(1, 1),
[EvalueLogId] [int] NOT NULL,
[GoalType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[GoalId] [int] NOT NULL,
[GoalXml] [xml] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEvalueGoal_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEvalueGoal] ADD CONSTRAINT [PK_TEvalueGoal] PRIMARY KEY NONCLUSTERED  ([EvalueGoalId])
GO
