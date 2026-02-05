CREATE TABLE [dbo].[TTask]
(
[TaskId] [int] NOT NULL IDENTITY(1, 1),
[StartDate] [datetime] NULL,
[DueDate] [datetime] NULL,
[PercentComplete] [int] NOT NULL CONSTRAINT [DF_TTask_PercentComplete] DEFAULT ((0)),
[Notes] [varchar] (8000) NULL,
[AssignedUserId] [int] NULL,
[PerformedUserId] [int] NULL,
[AssignedToUserId] [int] NULL,
[AssignedToRoleId] [int] NULL,
[ReminderId] [int] NULL,
[Subject] [varchar] (1000) NULL,
[RefPriorityId] [int] NULL,
[Other] [varchar] (8000) NULL,
[PrivateFg] [tinyint] NULL,
[DateCompleted] [datetime] NULL,
[EstimatedTimeHrs] [int] NULL,
[EstimatedTimeMins] [int] NULL,
[ActualTimeHrs] [int] NULL,
[ActualTimeMins] [int] NULL,
[CRMContactId] [int] NULL,
[URL] [varchar] (500) NULL,
[RefTaskStatusId] [int] NULL,
[ActivityOutcomeId] [int] NULL,
[SequentialRefLegacy] [varchar] (50) NULL,
[SequentialRef]  AS (CASE
                        WHEN [SequentialRefLegacy] IS NULL THEN 'IOT' + CASE
                                WHEN [TaskId] < 100000000 THEN RIGHT(REPLICATE('0', (8)) + CONVERT([varchar], [TaskId]), (8))
                                ELSE CONVERT([varchar], [TaskId])
                            END 
                        ELSE [SequentialRefLegacy]
                    END),
[IndigoClientId] [int] NOT NULL,
[ReturnToRoleId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TTask_ConcurrencyId] DEFAULT ((1)),
[ShowinDiary] [bit] NOT NULL CONSTRAINT [DF_TTask_ShowinDiary] DEFAULT ((0)),
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TTask_Guid] DEFAULT ([dbo].[NewCombGuid]()),
[IsAvailableToPFPClient] [bit] NOT NULL CONSTRAINT [DF_TTask_IsAvailableToPFPClient] DEFAULT ((0)),
[EstimatedAmount] [money] NULL,
[ActualAmount] [money] NULL,
[MigrationRef] [varchar] (255) NULL,
[LastUpdated] [datetime] NULL,
[OriginalDueDate] [DATETIME] NULL,
[IsBasedOnCompletionDate] [bit] NOT NULL CONSTRAINT [DF_TTask_IsBasedOnCompletionDate] DEFAULT ((0)),
[BillingRatePerHour] [money] NULL,
[SpentTimeHrs] [int] NULL,
[SpentTimeMins] [int] NULL,
[Timezone] [varchar] (100) NOT NUll,
[WorkflowName] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TTask] ADD CONSTRAINT [PK_TTask] PRIMARY KEY CLUSTERED  ([TaskId], [IndigoClientId])
GO
CREATE NONCLUSTERED INDEX [IDX_TTask_ActivityOutcomeId] ON [dbo].[TTask] ([ActivityOutcomeId])
GO
CREATE NONCLUSTERED INDEX [IDX_TTask_AssignedToRoleId] ON [dbo].[TTask] ([AssignedToRoleId])
GO
CREATE NONCLUSTERED INDEX [IDX_TTask_AssignedToUserId] ON [dbo].[TTask] ([AssignedToUserId])
GO
CREATE NONCLUSTERED INDEX [IDX_TTask_AssignedUserId] ON [dbo].[TTask] ([AssignedUserId])
GO
CREATE NONCLUSTERED INDEX [IDX_TTask_CRMContactId] ON [dbo].[TTask] ([CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IDX_TTask_DueDate] ON [dbo].[TTask] ([DueDate])
GO
ALTER TABLE [dbo].[TTask] WITH CHECK ADD CONSTRAINT [FK_TTask_RefPriorityId_RefPriorityId] FOREIGN KEY ([RefPriorityId]) REFERENCES [dbo].[TRefPriority] ([RefPriorityId])
GO
ALTER TABLE [dbo].[TTask] WITH CHECK ADD CONSTRAINT [FK_TTask_TRefTaskStatus] FOREIGN KEY ([RefTaskStatusId]) REFERENCES [dbo].[TRefTaskStatus] ([RefTaskStatusId])
GO
ALTER TABLE [dbo].[TTask] WITH CHECK ADD CONSTRAINT [FK_TTask_TReminder] FOREIGN KEY ([ReminderId]) REFERENCES [dbo].[TReminder] ([ReminderId])
GO
