CREATE TABLE [dbo].[TEvalueScenarioRiskLog]
(
[EvalueScenarioRiskLogId] [int] NOT NULL IDENTITY(1, 1),
[EvalueLogId] [int] NOT NULL,
[ScenarioId] [int] NOT NULL,
[Term] [int] NOT NULL,
[GroupCode] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Result] [xml] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
