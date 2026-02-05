CREATE TABLE [dbo].[TValSchedule]
(
[ValScheduleId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Guid] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ScheduledLevel] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[RefProdProviderId] [int] NOT NULL,
[RefGroupId] [int] NULL,
[ClientCRMContactId] [int] NULL,
[UserCredentialOption] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[PortalCRMContactId] [int] NULL,
[StartDate] [datetime] NULL,
[Frequency] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsLocked] [bit] NOT NULL CONSTRAINT [DF_TValSchedule_IsLocked] DEFAULT ((0)),
[UserNameForFileAccess] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[PasswordForFileAccess] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Password2ForFileAccess] [varbinary] (4000) NULL,
[CreatedByUserId] [int] NULL ,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValSchedule_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TValSchedule] ADD CONSTRAINT [PK_TValSchedule] PRIMARY KEY NONCLUSTERED  ([ValScheduleId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TValSchedule_IndigoClientId] ON [dbo].[TValSchedule] ([IndigoClientId])
GO
CREATE NONCLUSTERED INDEX [IDX_TValSchedule_ScheduledLevel] ON [dbo].[TValSchedule] ([ScheduledLevel]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TValSchedule_ScheduledLevel_StartDate] ON [dbo].[TValSchedule] ([ScheduledLevel], [StartDate]) INCLUDE ([IndigoClientId], [PortalCRMContactId], [RefProdProviderId], [ValScheduleId])
GO
CREATE NONCLUSTERED INDEX IX_TValSchedule_RefProdProviderId ON [dbo].[TValSchedule] ([RefProdProviderId]) INCLUDE ([ValScheduleId],[ScheduledLevel],[IndigoClientId],[PortalCRMContactId],[Frequency])
GO
ALTER TABLE [dbo].[TValSchedule] SET ( LOCK_ESCALATION = DISABLE )
GO