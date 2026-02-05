CREATE TABLE [dbo].[TBackgroundServiceActiveAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[EntityName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[EntityId] [int] NULL,
[StartDateTime] [datetime] NOT NULL CONSTRAINT [DF_TBackgroundServiceActiveAudit_StartDateTime] DEFAULT (getdate()),
[ServerName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[UserId] [char] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TBackgroundServiceActiveAudit_ConcurrencyId] DEFAULT ((1)),
[BackgroundServiceActiveId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TBackgroundServiceActiveAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TBackgroundServiceActiveAudit] ADD CONSTRAINT [PK_TBackgroundServiceActiveAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TBackgroundServiceActiveAudit_BackgroundServiceActiveId_ConcurrencyId] ON [dbo].[TBackgroundServiceActiveAudit] ([BackgroundServiceActiveId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
