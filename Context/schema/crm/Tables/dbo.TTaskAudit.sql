CREATE TABLE [dbo].[TTaskAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[StartDate] [datetime] NULL,
[DueDate] [datetime] NULL,
[PercentComplete] [int] NOT NULL CONSTRAINT [DF_TTaskAudit_PercentComplete] DEFAULT ((0)),
[Notes] [varchar] (8000) COLLATE Latin1_General_CI_AS NULL,
[AssignedUserId] [int] NULL,
[PerformedUserId] [int] NULL,
[AssignedToUserId] [int] NULL,
[AssignedToRoleId] [int] NULL,
[ReminderId] [int] NULL,
[Subject] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[RefPriorityId] [int] NULL,
[Other] [varchar] (8000) COLLATE Latin1_General_CI_AS NULL,
[PrivateFg] [tinyint] NULL,
[DateCompleted] [datetime] NULL,
[EstimatedTimeHrs] [int] NULL,
[EstimatedTimeMins] [int] NULL,
[ActualTimeHrs] [int] NULL,
[ActualTimeMins] [int] NULL,
[CRMContactId] [int] NULL,
[URL] [varchar] (500) COLLATE Latin1_General_CI_AS NULL,
[RefTaskStatusId] [int] NULL,
[ActivityOutcomeId] [int] NULL,
[SequentialRef] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NOT NULL,
[ReturnToRoleId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TTaskAudit_ConcurrencyId] DEFAULT ((1)),
[EstimatedAmount] [money] NULL,
[ActualAmount] [money] NULL,
[TaskId] [int] NOT NULL,
[ShowinDiary] [bit] NULL,
[Guid] [uniqueidentifier] NULL,
[IsAvailableToPFPClient] [bit] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TTaskAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsBasedOnCompletionDate] [bit] NULL,
[MigrationRef] [varchar] (255) NULL,
[OriginalDueDate] [DATETIME] NULL,
[BillingRatePerHour] [money] NULL,
[SpentTimeHrs] [int] NULL,
[SpentTimeMins] [int] NULL,
[Timezone] [varchar] (100) NOT NULL CONSTRAINT [DF_TTaskAudit_Timezone]  DEFAULT ('Europe/London'),
[WorkflowName] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TTaskAudit] ADD CONSTRAINT [PK_TTaskAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=75)
GO
CREATE NONCLUSTERED INDEX [IX_TTaskAudit_StampDateTime] ON [dbo].[TTaskAudit] ([StampDateTime])
GO
CREATE NONCLUSTERED INDEX [IX_TTaskAudit_TaskId] ON [dbo].[TTaskAudit] ([TaskId])
GO
