CREATE TABLE [dbo].[TLeadImportTemp]
(
[LeadImportId] [int] NOT NULL,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[EntryDate] [datetime] NOT NULL,
[FileName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[FileLocation] [varchar] (1000) COLLATE Latin1_General_CI_AS NOT NULL,
[FileUrl] [varchar] (1000) COLLATE Latin1_General_CI_AS NOT NULL,
[DocVersionId] [int] NULL,
[NumberImported] [int] NOT NULL,
[NumberFailed] [int] NOT NULL,
[Defer] [bit] NOT NULL,
[Imported] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
