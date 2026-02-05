CREATE TABLE [dbo].[TProcessStepAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ProcessId] [int] NOT NULL,
[WorkflowStepId] [int] NOT NULL,
[CompletedFg] [int] NOT NULL,
[TaskId] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[ProcessStepId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TProcessStepAudit] ADD CONSTRAINT [PK_TProcessStepAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
