CREATE TABLE [dbo].[TBackgroundServiceHistoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[EntityName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[EntityId] [int] NULL,
[OtherInfo] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[StartDateTime] [datetime] NOT NULL CONSTRAINT [DF_TBackgroundServiceHistoryAudit_StartDateTime] DEFAULT (getdate()),
[EndDateTime] [datetime] NULL,
[ServerName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[UserId] [int] NOT NULL,
[RefBackgroundServiceStatusId] [int] NOT NULL,
[DataVersion] [int] NULL CONSTRAINT [DF_TBackgroundServiceHistoryAudit_DataVersion] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TBackgroundServiceHistoryAudit_ConcurrencyId] DEFAULT ((1)),
[BackgroundServiceHistoryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TBackgroundServiceHistoryAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TBackgroundServiceHistoryAudit] ADD CONSTRAINT [PK_TBackgroundServiceHistoryAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TBackgroundServiceHistoryAudit_BackgroundServiceHistoryId_ConcurrencyId] ON [dbo].[TBackgroundServiceHistoryAudit] ([BackgroundServiceHistoryId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
