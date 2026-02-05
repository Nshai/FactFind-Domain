CREATE TABLE [dbo].[TOutlookExtensionUserOptionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NULL,
[SyncDiaryAppointments] [bit]  NULL,
[IsSetupNotificationSent] [bit]  NULL,
[ConcurrencyId] [int]  NULL,
[OutlookExtensionUserOptionId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TOutlookExtensionUserOptionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO