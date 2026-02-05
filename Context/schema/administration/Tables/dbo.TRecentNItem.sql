CREATE TABLE [dbo].[TRecentNItem]
(
[RecentNItemId] [int] NOT NULL IDENTITY(1, 1),
[RecentSearchAndReportId] [int] NULL,
[RecentItemId] [int] NOT NULL,
[LastUpdated] [datetime] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRecentNItem_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRecentNItem] ADD CONSTRAINT [PK_TRecentNItem] PRIMARY KEY NONCLUSTERED  ([RecentNItemId]) WITH (FILLFACTOR=75)
GO
CREATE NONCLUSTERED INDEX [IX_TRecentNItem_RecentSearchAndReportId_LastUpdated_RecentItemId] ON [dbo].[TRecentNItem] ([RecentSearchAndReportId], [LastUpdated], [RecentItemId])
GO
ALTER TABLE [dbo].[TRecentNItem] ADD CONSTRAINT [FK_TRecentNItem_TRecentSearchAndReport] FOREIGN KEY ([RecentSearchAndReportId]) REFERENCES [dbo].[TRecentSearchAndReport] ([RecentSearchAndReportId])
GO
