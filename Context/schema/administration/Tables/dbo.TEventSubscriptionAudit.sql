CREATE TABLE [dbo].[TEventSubscriptionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[EventSubscriptionId] [int] NOT NULL,
[EntityId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[IsPersistent] [bit] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[EventType] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[AdditionalContext] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[CallbackUrl] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TEventSubscriptionAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Metadata] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[Priority] [tinyint] NOT NULL CONSTRAINT [DF_TEventSubscriptionAudit_Priority] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEventSubscriptionAudit] ADD CONSTRAINT [PK_TEventSubscriptionAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
