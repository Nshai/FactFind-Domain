CREATE TABLE [dbo].[TLeadImport]
(
[LeadImportId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[EntryDate] [datetime] NOT NULL CONSTRAINT [DF_TLeadImport_EntryDate] DEFAULT (getdate()),
[FileName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[FileLocation] [varchar] (1000) COLLATE Latin1_General_CI_AS NOT NULL,
[FileUrl] [varchar] (1000) COLLATE Latin1_General_CI_AS NOT NULL,
[DocVersionId] [int] NULL,
[NumberImported] [int] NOT NULL CONSTRAINT [DF_TLeadImport_NumberImported] DEFAULT ((0)),
[NumberFailed] [int] NOT NULL CONSTRAINT [DF_TLeadImport_NumberFailed] DEFAULT ((0)),
[NumberDuplicates] [int] NOT NULL CONSTRAINT [DF_TLeadImport_NumberDuplicates] DEFAULT ((0)),
[Defer] [bit] NOT NULL CONSTRAINT [DF_TLeadImport_Defer] DEFAULT ((0)),
[Imported] [bit] NOT NULL CONSTRAINT [DF_TLeadImport_Complete] DEFAULT ((0)),
[ImportDuplicates] [bit] NOT NULL CONSTRAINT [DF_TLeadImport_ImportDuplicates] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLeadImport_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TLeadImport] ADD CONSTRAINT [PK_TLeadImport] PRIMARY KEY CLUSTERED  ([LeadImportId]) WITH (FILLFACTOR=80)
GO
