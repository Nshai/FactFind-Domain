CREATE TABLE [dbo].[TBackgroundServiceHistoryItemAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[BackgroundServiceHistoryId] [int] NOT NULL,
[StartDateTime] [datetime] NOT NULL CONSTRAINT [DF_TBackgroundServiceHistoryItemAudit_StartDateTime] DEFAULT (getdate()),
[EndDateTime] [datetime] NULL,
[ErrorMessage] [varchar] (3000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TBackgroundServiceHistoryItemAudit_ConcurrencyId] DEFAULT ((1)),
[BackgroundServiceHistoryItemId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TBackgroundServiceHistoryItemAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TBackgroundServiceHistoryItemAudit] ADD CONSTRAINT [PK_TBackgroundServiceHistoryItemAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TBackgroundServiceHistoryItemAudit_BackgroundServiceHistoryItemId_ConcurrencyId] ON [dbo].[TBackgroundServiceHistoryItemAudit] ([BackgroundServiceHistoryItemId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
