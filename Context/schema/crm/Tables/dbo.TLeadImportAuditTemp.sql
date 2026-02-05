CREATE TABLE [dbo].[TLeadImportAuditTemp]
(
[AuditId] [int] NOT NULL,
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
[ConcurrencyId] [int] NOT NULL,
[LeadImportId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
