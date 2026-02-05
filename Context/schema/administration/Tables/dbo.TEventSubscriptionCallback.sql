CREATE TABLE [dbo].[TEventSubscriptionCallback]
(
[Id] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[AppliedDateTime] [datetime] NULL,
[EventName] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ContextData] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ErrorMessage] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[StackTrace] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[AttemptCount] [int] NOT NULL CONSTRAINT [DF_TEventSubscriptionCallback_AttemptCount] DEFAULT ((0)),
[Priority] [tinyint] NOT NULL CONSTRAINT [DF_TEventSubscriptionCallback_Priority] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEventSubscriptionCallback] ADD CONSTRAINT [PK_TEventSubscriptionCallback] PRIMARY KEY CLUSTERED  ([Id])
GO
CREATE NONCLUSTERED INDEX [IX_TEventSubscriptionCallback_Id_AppliedDateTime] ON [dbo].[TEventSubscriptionCallback] ([Id], [AppliedDateTime])
GO
CREATE NONCLUSTERED INDEX IX_TEventSubscriptionCallback_AppliedDateTime_Id_AttemptCount ON [dbo].[TEventSubscriptionCallback] ([AppliedDateTime],[Id],[AttemptCount])
GO