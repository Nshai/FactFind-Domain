CREATE TABLE [dbo].[TRefRecentSearchAndReportType]
(
[RefRecentSearchAndReportTypeId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[Archived] [bit] NOT NULL CONSTRAINT [DF_TRefRecentSearchAndReportType_Archived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefRecentSearchAndReportType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefRecentSearchAndReportType] ADD CONSTRAINT [PK_TRefRecentSearchAndReportType] PRIMARY KEY CLUSTERED  ([RefRecentSearchAndReportTypeId]) WITH (FILLFACTOR=75)
GO
