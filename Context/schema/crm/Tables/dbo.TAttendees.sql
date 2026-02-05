CREATE TABLE [dbo].[TAttendees]
(
[AttendeesId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[AppointmentId] [int] NOT NULL,
[CRMContactId] [int] NULL,
[RefAcceptanceStatusId] [int] NOT NULL,
[OrganiserFG] [bit] NOT NULL CONSTRAINT [DF_TAttendees_OrganiserFG] DEFAULT ((0)),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Email] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAttendees_ConcurrencyId] DEFAULT ((1)),
[BillingRatePerHour] [money] NULL
)
GO
ALTER TABLE [dbo].[TAttendees] ADD CONSTRAINT [PK_TAttendees_AttendeesId] PRIMARY KEY NONCLUSTERED  ([AttendeesId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TAttendees_AppointmentIdASC] ON [dbo].[TAttendees] ([AppointmentId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TAttendees_RefAcceptanceStatusIdASC] ON [dbo].[TAttendees] ([RefAcceptanceStatusId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TAttendees] ADD CONSTRAINT [FK_TAttendees_AppointmentId_AppointmentId] FOREIGN KEY ([AppointmentId]) REFERENCES [dbo].[TAppointment] ([AppointmentId])
GO
ALTER TABLE [dbo].[TAttendees] ADD CONSTRAINT [FK_TAttendees_RefAcceptanceStatusId_RefAcceptanceStatusId] FOREIGN KEY ([RefAcceptanceStatusId]) REFERENCES [dbo].[TRefAcceptanceStatus] ([RefAcceptanceStatusId])
GO
CREATE NONCLUSTERED INDEX IX_TAttendees_CRMContactId ON [dbo].[TAttendees] ([CRMContactId])
GO