CREATE TABLE [dbo].[TNotification]
(
[NotificationId] [uniqueidentifier] NOT NULL,
[UserId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[Title] [nvarchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Text] [nvarchar] (max) COLLATE Latin1_General_CI_AS NOT NULL,
[RelevantUntil] [datetime] NOT NULL,
[ReadAfter] [datetime] NOT NULL,
[IsRead] [bit] NOT NULL,
[Type] [int] NOT NULL,
[Options] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ReadDate] [datetime] NULL
)
GO
CREATE NONCLUSTERED INDEX [IX_TNotification_UserId_TenantId_RelevantUntil_ReadAfter_IsRead] ON [dbo].[TNotification] ([UserId], [TenantId], [RelevantUntil], [ReadAfter], [IsRead])
GO
create index IX_TNotification_NotificationId on TNotification (NotificationId) 
go
create index IX_TNotification_UserId on TNotification (UserId)
go