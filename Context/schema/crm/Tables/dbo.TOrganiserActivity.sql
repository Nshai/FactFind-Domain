CREATE TABLE [dbo].[TOrganiserActivity]
(
[OrganiserActivityId] [int] NOT NULL IDENTITY(1, 1),
[AppointmentId] [int] NULL,
[ActivityCategoryParentId] [int] NULL,
[ActivityCategoryId] [int] NULL,
[TaskId] [int] NULL,
[CompleteFG] [bit] NOT NULL CONSTRAINT [DF_TOrganiserActivity_Complete] DEFAULT ((0)),
[PolicyId] [int] NULL,
[FeeId] [int] NULL,
[RetainerId] [int] NULL,
[OpportunityId] [int] NULL,
[EventListActivityId] [int] NULL,
[CRMContactId] [int] NULL,
[JointCRMContactId] [int] NULL,
[IndigoClientId] [int] NULL,
[AdviceCaseId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TOrganiserActivity_ConcurrencyId] DEFAULT ((1)),
[IsRecurrence] [bit] NULL CONSTRAINT [DF_TOrganiserActivity_IsRecurrence] DEFAULT ((0)),
[RecurrenceSeriesId] [varchar] (250) NULL,
[MigrationRef] [varchar] (255) NULL,
[CreatedDate] [datetime] NULL CONSTRAINT [DF_TOrganiserActivity_CreatedDate] DEFAULT (getdate()),
[CreatedByUserId] [int] NULL,
[UpdatedOn] [datetime] NULL,
[UpdatedByUserId] [int] NULL,
[PropertiesJson] [nvarchar] (4000) NULL
)
GO
ALTER TABLE [dbo].[TOrganiserActivity] ADD CONSTRAINT [PK_TOrganiserActivity] PRIMARY KEY CLUSTERED  ([OrganiserActivityId])
GO
CREATE NONCLUSTERED INDEX [IX_INCL_ActivityCategoryId] ON [dbo].[TOrganiserActivity] ([ActivityCategoryId]) INCLUDE ([ActivityCategoryParentId])
GO
CREATE NONCLUSTERED INDEX [IX_TOrganiserActivity_AppointmentIdASC] ON [dbo].[TOrganiserActivity] ([AppointmentId])
GO

CREATE NONCLUSTERED INDEX [IX_TOrganiserActivity_CRMContactIdASC] ON [dbo].[TOrganiserActivity] ([CRMContactId])
CREATE NONCLUSTERED INDEX [IX_TOrganiserActivity_EventListActivityIdASC] ON [dbo].[TOrganiserActivity] ([EventListActivityId])
CREATE NONCLUSTERED INDEX IX_TOrganiserActivity_TaskId_IndigoClientId ON [dbo].[TOrganiserActivity] ([TaskId], [IndigoClientId])
GO
GO
CREATE NONCLUSTERED INDEX [IX_TOrganiserActivity_PolicyId_IndigoClientId] ON [dbo].[TOrganiserActivity] ([PolicyId], [IndigoClientId]) INCLUDE ([AdviceCaseId], [CompleteFG], [CRMContactId], [EventListActivityId], [FeeId], [OpportunityId], [OrganiserActivityId], [RetainerId], [TaskId])
GO
CREATE NONCLUSTERED INDEX [IX_TOrganiserActivity_TaskId] ON [dbo].[TOrganiserActivity] ([TaskId]) include (JointCRMContactId)
GO
ALTER TABLE [dbo].[TOrganiserActivity] WITH CHECK ADD CONSTRAINT [FK_TOrganiserActivity_ActivityCategoryId_ActivityCategoryId] FOREIGN KEY ([ActivityCategoryId]) REFERENCES [dbo].[TActivityCategory] ([ActivityCategoryId])
GO
ALTER TABLE [dbo].[TOrganiserActivity] WITH CHECK ADD CONSTRAINT [FK_TOrganiserActivity_TActivityCategoryParent] FOREIGN KEY ([ActivityCategoryParentId]) REFERENCES [dbo].[TActivityCategoryParent] ([ActivityCategoryParentId])
GO
ALTER TABLE [dbo].[TOrganiserActivity] WITH CHECK ADD CONSTRAINT [FK_TOrganiserActivity_AppointmentId_AppointmentId] FOREIGN KEY ([AppointmentId]) REFERENCES [dbo].[TAppointment] ([AppointmentId])
GO
ALTER TABLE [dbo].[TOrganiserActivity] WITH CHECK ADD CONSTRAINT [FK_TOrganiserActivity_TCRMContact] FOREIGN KEY ([CRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
ALTER TABLE [dbo].[TOrganiserActivity] WITH CHECK ADD CONSTRAINT [FK_TOrganiserActivity_EventListActivityId_EventListActivityId] FOREIGN KEY ([EventListActivityId]) REFERENCES [dbo].[TEventListActivity] ([EventListActivityId])
GO
ALTER TABLE [dbo].[TOrganiserActivity] WITH CHECK ADD CONSTRAINT [FK_TOrganiserActivity_TTask] FOREIGN KEY ([TaskId], [IndigoClientId]) REFERENCES [dbo].[TTask] ([TaskId], [IndigoClientId])
GO
CREATE NONCLUSTERED INDEX IX_TOrganiserActivity_IndigoClientId_JointCRMContactId ON [dbo].[TOrganiserActivity] ([IndigoClientId],[JointCRMContactId]) INCLUDE ([TaskId]) 

GO
