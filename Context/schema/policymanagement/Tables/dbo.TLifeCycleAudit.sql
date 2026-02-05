CREATE TABLE [dbo].[TLifeCycleAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[Descriptor] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Status] [int] NOT NULL CONSTRAINT [DF_TLifeCycleAudit_Status] DEFAULT ((0)),
[PreQueueBehaviour] [varchar] (150) COLLATE Latin1_General_CI_AS NULL,
[PostQueueBehaviour] [varchar] (150) COLLATE Latin1_General_CI_AS NULL,
[CreatedDate] [datetime] NULL,
[CreatedUser] [int] NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLifeCycleAudit_ConcurrencyId] DEFAULT ((1)),
[LifeCycleId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TLifeCycleAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IgnorePostCheckIfPreHasBeenCompleted] [bit] NULL
)
GO
ALTER TABLE [dbo].[TLifeCycleAudit] ADD CONSTRAINT [PK_TLifeCycleAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
