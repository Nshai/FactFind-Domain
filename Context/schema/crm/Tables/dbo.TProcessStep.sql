CREATE TABLE [dbo].[TProcessStep]
(
[ProcessStepId] [int] NOT NULL IDENTITY(1, 1),
[ProcessId] [int] NOT NULL,
[WorkflowStepId] [int] NOT NULL,
[TaskId] [int] NULL,
[CompletedFg] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TProcessStep] ADD CONSTRAINT [PK_TProcessStep] PRIMARY KEY CLUSTERED  ([ProcessStepId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TProcessStep_TaskId] ON [dbo].[TProcessStep] ([TaskId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TProcessStep_WorkflowStepId] ON [dbo].[TProcessStep] ([WorkflowStepId]) WITH (FILLFACTOR=80)
GO
