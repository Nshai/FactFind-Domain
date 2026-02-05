CREATE TABLE [dbo].[TRecentSearchAndReportAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[Controller] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[Action] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[URL] [varchar] (1000) COLLATE Latin1_General_CI_AS NOT NULL,
[LastUpdated] [datetime] NOT NULL,
[RefRecentSearchAndReportTypeId] [int] NOT NULL CONSTRAINT [DF_TRecentSearchAndReportAudit_RefRecentSearchAndReportTypeId] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRecentSearchAndReportAudit_ConcurrencyId] DEFAULT ((1)),
[RecentSearchAndReportId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRecentSearchAndReportAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRecentSearchAndReportAudit] ADD CONSTRAINT [PK_TRecentSearchAndReportAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRecentSearchAndReportAudit_RecentSearchAndReportId_ConcurrencyId] ON [dbo].[TRecentSearchAndReportAudit] ([RecentSearchAndReportId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
