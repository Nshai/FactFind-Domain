CREATE TABLE [dbo].[TRefRecentSearchAndReportTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[Archived] [bit] NOT NULL CONSTRAINT [DF_TRefRecentSearchAndReportTypeAudit_Archived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefRecentSearchAndReportTypeAudit_ConcurrencyId] DEFAULT ((1)),
[RefRecentSearchAndReportTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefRecentSearchAndReportTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefRecentSearchAndReportTypeAudit] ADD CONSTRAINT [PK_TRefRecentSearchAndReportTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TRefRecentSearchAndReportTypeAudit_RefRecentSearchAndReportTypeId_ConcurrencyId] ON [dbo].[TRefRecentSearchAndReportTypeAudit] ([RefRecentSearchAndReportTypeId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
