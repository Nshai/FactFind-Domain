CREATE TABLE [dbo].[TEvaluePOD]
(
[EvaluePODId] [int] NOT NULL IDENTITY(1, 1),
[EvalueLogId] [int] NOT NULL,
[GoalType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[GoalId] [int] NOT NULL,
[ScenarioIds] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ParameterXml] [xml] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEvaluePOD_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEvaluePOD] ADD CONSTRAINT [PK_TEvaluePOD] PRIMARY KEY NONCLUSTERED  ([EvaluePODId])
GO
