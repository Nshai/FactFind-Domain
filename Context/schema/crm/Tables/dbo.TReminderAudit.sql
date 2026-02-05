CREATE TABLE [dbo].[TReminderAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ReminderDate] [datetime] NULL,
[EmailNotificationFg] [tinyint] NULL,
[IndClientId] [int] NULL,
[ReminderHours] [tinyint] NULL,
[ReminderMinutes] [tinyint] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TReminderAudit_ConcurrencyId] DEFAULT ((1)),
[ReminderId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TReminderAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TReminderAudit] ADD CONSTRAINT [PK_TReminderAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
