CREATE TABLE [dbo].[TRecentNItemAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RecentSearchAndReportId] [int] NOT NULL,
[RecentItemId] [int] NULL,
[LastUpdated] [datetime] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRecentNItemAudit_ConcurrencyId] DEFAULT ((1)),
[RecentNItemId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRecentNItemAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRecentNItemAudit] ADD CONSTRAINT [PK_TRecentNItemAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRecentNItemAudit_RecentNItemId_ConcurrencyId] ON [dbo].[TRecentNItemAudit] ([RecentNItemId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
