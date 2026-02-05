CREATE TABLE [dbo].[TAppointmentAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Subject] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[AddressStoreId] [int] NULL,
[Location] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[OrganizerCRMContactId] [int] NOT NULL,
[ScratchFG] [bit] NOT NULL CONSTRAINT [DF_TAppointmentAudit_ScratchFG] DEFAULT ((0)),
[StartTime] [datetime] NULL,
[EndTime] [datetime] NULL,
[AllDayEventFG] [bit] NOT NULL CONSTRAINT [DF_TAppointmentAudit_AllDayEventFG] DEFAULT ((0)),
[ShowTimeAs] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Notes] [varchar] (8000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NULL,
[ReminderId] [int] NULL,
[RefClassificationId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAppointmentAudit_ConcurrencyId] DEFAULT ((1)),
[AppointmentId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAppointmentAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ActivityOutcomeId] [int] NULL,
[CreatedByUserId] [int] NULL,
[Guid] [uniqueidentifier]  NULL,
[Timezone] [varchar] (100) NOT NULL CONSTRAINT [DF_TAppointmentAudit_Timezone]  DEFAULT ('Europe/London')
)
GO
ALTER TABLE [dbo].[TAppointmentAudit] ADD CONSTRAINT [PK_TAppointmentAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAppointmentAudit_StampDateTime] ON [dbo].[TAppointmentAudit] (StampDateTime) INCLUDE (AppointmentId)