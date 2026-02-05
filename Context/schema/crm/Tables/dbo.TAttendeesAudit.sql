CREATE TABLE [dbo].[TAttendeesAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AppointmentId] [int] NOT NULL,
[CRMContactId] [int] NULL,
[RefAcceptanceStatusId] [int] NOT NULL,
[OrganiserFG] [bit] NOT NULL CONSTRAINT [DF_TAttendeesAudit_OrganiserFG] DEFAULT ((0)),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Email] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAttendeesAudit_ConcurrencyId] DEFAULT ((1)),
[AttendeesId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAttendeesAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[BillingRatePerHour] [money] NULL
)
GO
ALTER TABLE [dbo].[TAttendeesAudit] ADD CONSTRAINT [PK_TAttendeesAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
