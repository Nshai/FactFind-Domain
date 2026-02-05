CREATE TABLE [dbo].[TEvalueGoalAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[EvalueLogId] [int] NOT NULL,
[GoalType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[GoalId] [int] NOT NULL,
[GoalXml] [xml] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[EvalueGoalId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TEvalueGoalAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEvalueGoalAudit] ADD CONSTRAINT [PK_TEvalueGoalAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TEvalueGoalAudit_EvalueGoalId_ConcurrencyId] ON [dbo].[TEvalueGoalAudit] ([EvalueGoalId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
