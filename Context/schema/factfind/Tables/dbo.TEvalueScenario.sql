CREATE TABLE [dbo].[TEvalueScenario]
(
[EvalueScenarioId] [int] NOT NULL IDENTITY(1, 1),
[EvalueLogId] [int] NOT NULL,
[GoalType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[GoalId] [int] NOT NULL,
[ScenarioId] [int] NOT NULL,
[ScenarioXml] [xml] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEvalueScenario_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TEvalueScenario] ADD CONSTRAINT [PK_TEvalueScenario] PRIMARY KEY NONCLUSTERED  ([EvalueScenarioId])
GO
CREATE NONCLUSTERED INDEX IX_TEvalueScenario_EvalueLogId ON [dbo].[TEvalueScenario] ([EvalueLogId])
go