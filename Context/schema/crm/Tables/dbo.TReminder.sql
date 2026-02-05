CREATE TABLE [dbo].[TReminder]
(
[ReminderId] [int] NOT NULL IDENTITY(1, 1),
[ReminderDate] [datetime] NULL,
[EmailNotificationFg] [tinyint] NULL,
[IndClientId] [int] NULL,
[ReminderHours] [tinyint] NULL,
[ReminderMinutes] [tinyint] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TReminder_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TReminder] ADD CONSTRAINT [PK_TReminder_ReminderId] PRIMARY KEY NONCLUSTERED  ([ReminderId]) WITH (FILLFACTOR=80)
GO
