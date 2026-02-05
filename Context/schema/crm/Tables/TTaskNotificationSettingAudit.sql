CREATE TABLE [dbo].[TTaskNotificationSettingAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] Not Null,
[UserId] [int] Not Null,
[NotifyOnAssignment] [bit] Not Null,
[TaskNotificationSettingId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TTaskNotificationSetting_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
)
GO
ALTER TABLE [dbo].[TTaskNotificationSettingAudit] ADD CONSTRAINT [PK_TTaskNotificationSettingAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) 
GO
CREATE NONCLUSTERED INDEX [IDX_TTaskNotificationSettingAudit_StampDateTime_TaskNotificationSettingId] ON [dbo].[TTaskNotificationSettingAudit] (StampDateTime, TaskNotificationSettingId) 
go