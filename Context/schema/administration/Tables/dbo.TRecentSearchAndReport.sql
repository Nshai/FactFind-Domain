CREATE TABLE [dbo].[TRecentSearchAndReport]
(
[RecentSearchAndReportId] [int] NOT NULL IDENTITY(1, 1),
[UserId] [int] NOT NULL,
[Controller] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[Action] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[URL] [varchar] (1000) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_TRecentSearchAndReport_URL] DEFAULT (''),
[LastUpdated] [datetime] NOT NULL,
[RefRecentSearchAndReportTypeId] [int] NOT NULL CONSTRAINT [DF_TRecentSearchAndReport_RefRecentSearchAndReportTypeId] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRecentSearchAndReport_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRecentSearchAndReport] ADD CONSTRAINT [PK_TRecentSearchAndReport] PRIMARY KEY NONCLUSTERED  ([RecentSearchAndReportId]) WITH (FILLFACTOR=75)
GO
CREATE NONCLUSTERED INDEX [IX_TRecentSearchAndReport_UserId_Controller_Action] ON [dbo].[TRecentSearchAndReport] ([UserId], [Controller], [Action])
GO
ALTER TABLE [dbo].[TRecentSearchAndReport] ADD CONSTRAINT [FK_TRecentSearchAndReport_TRefRecentSearchAndReportType] FOREIGN KEY ([RefRecentSearchAndReportTypeId]) REFERENCES [dbo].[TRefRecentSearchAndReportType] ([RefRecentSearchAndReportTypeId])
GO
