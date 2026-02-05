CREATE TABLE [dbo].[TAppointment]
(
[AppointmentId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Subject] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[AddressStoreId] [int] NULL,
[Location] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[OrganizerCRMContactId] [int] NOT NULL,
[ScratchFG] [bit] NOT NULL CONSTRAINT [DF_TAppointment_ScratchFG] DEFAULT ((0)),
[StartTime] [datetime] NULL,
[EndTime] [datetime] NULL,
[AllDayEventFG] [bit] NOT NULL CONSTRAINT [DF_TAppointment_AllDayEventFG] DEFAULT ((0)),
[ShowTimeAs] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Notes] [varchar] (8000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NULL CONSTRAINT [DF_TAppointment_CRMContactId] DEFAULT (NULL),
[ReminderId] [int] NULL,
[RefClassificationId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAppointment_ConcurrencyId] DEFAULT ((1)),
[ActivityOutcomeId] [int] NULL,
[CreatedByUserId] [int] NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TAppointment_Guid] DEFAULT (newid()),
[Timezone] [varchar] (100) NOT NULL
)
GO
ALTER TABLE [dbo].[TAppointment] ADD CONSTRAINT [PK_TAppointment_AppointmentId] PRIMARY KEY NONCLUSTERED  ([AppointmentId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TAppointment_CRMContactIdASC] ON [dbo].[TAppointment] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TAppointment_ReminderIdASC] ON [dbo].[TAppointment] ([ReminderId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TAppointment] ADD CONSTRAINT [FK_TAppointment_ReminderId_ReminderId] FOREIGN KEY ([ReminderId]) REFERENCES [dbo].[TReminder] ([ReminderId])
GO
