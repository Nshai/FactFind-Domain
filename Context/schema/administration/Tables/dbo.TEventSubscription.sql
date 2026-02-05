CREATE TABLE [dbo].[TEventSubscription]
(
[EventSubscriptionId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[EntityId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[IsPersistent] [bit] NOT NULL CONSTRAINT [DF_TEventSubscription_IsPersistent] DEFAULT ((0)),
[CreatedDate] [datetime] NOT NULL,
[EventType] [Varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[AdditionalContext] [Varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[CallbackUrl] [Varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEventSubscription_ConcurrencyId] DEFAULT ((1)),
[Metadata] [Varchar] (max) null,
[Priority] [tinyint] NOT NULL CONSTRAINT [DF_TEventSubscription_Priority] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEventSubscription] ADD CONSTRAINT [PK_TEventSubscription] PRIMARY KEY CLUSTERED  ([EventSubscriptionId])
GO
CREATE NONCLUSTERED INDEX CIX_TEventSubscription_EntityId_TenantId ON dbo.TEventSubscription (EntityId, TenantId)
GO
CREATE NONCLUSTERED INDEX CIX_TEventSubscription_TenantId_EventType ON dbo.TEventSubscription (TenantId, EventType)
GO