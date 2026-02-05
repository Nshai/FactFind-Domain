CREATE TABLE [dbo].[TActivityRecurrenceAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RFCCode] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[OrganiserActivityId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TActivityRecurrenceAudit_ConcurrencyId] DEFAULT ((1)),
[ActivityRecurrenceId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TActivityRecurrenceAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TActivityRecurrenceAudit] ADD CONSTRAINT [PK_TActivityRecurrenceAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TActivityRecurrenceAudit_ActivityRecurrenceId] ON [dbo].[TActivityRecurrenceAudit] ([ActivityRecurrenceId]) WITH (FILLFACTOR=80)
GO
