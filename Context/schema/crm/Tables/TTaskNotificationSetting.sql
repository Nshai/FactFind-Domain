CREATE TABLE [dbo].[TTaskNotificationSetting]
(
[TaskNotificationSettingId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[TenantId] [int] Not Null,
[UserId] [int] Not Null,
[NotifyOnAssignment] [bit] Not Null
)
GO
ALTER TABLE [dbo].[TTaskNotificationSetting] ADD CONSTRAINT [PK_TTaskNotificationSetting] PRIMARY KEY NONCLUSTERED  ([TaskNotificationSettingId]) 
GO
CREATE NONCLUSTERED INDEX [IDX_TTaskNotificationSetting_TenantId_UserId] ON [dbo].[TTaskNotificationSetting] ([TenantId], [UserId]) INCLUDE ([NotifyOnAssignment]) 
GO
ALTER TABLE TTaskNotificationSetting ADD CONSTRAINT [UQ_TTaskNotificationSetting] UNIQUE (TenantId, UserId)
GO