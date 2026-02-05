CREATE TABLE [dbo].[TEvalueScenarioAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[EvalueLogId] [int] NOT NULL,
[GoalType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[GoalId] [int] NOT NULL,
[ScenarioId] [int] NOT NULL,
[ScenarioXml] [xml] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEvalueScenarioAudit_ConcurrencyId] DEFAULT ((0)),
[EvalueScenarioId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TEvalueScenarioAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEvalueScenarioAudit] ADD CONSTRAINT [PK_TEvalueScenarioAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TEvalueScenarioAudit_EvalueScenarioId_ConcurrencyId] ON [dbo].[TEvalueScenarioAudit] ([EvalueScenarioId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
