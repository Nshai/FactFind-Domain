CREATE TABLE [dbo].[TEvaluePODAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[EvalueLogId] [int] NOT NULL,
[GoalType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[GoalId] [int] NOT NULL,
[ScenarioIds] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ParameterXml] [xml] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEvaluePODAudit_ConcurrencyId] DEFAULT ((1)),
[EvaluePODId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TEvaluePODAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEvaluePODAudit] ADD CONSTRAINT [PK_TEvaluePODAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
