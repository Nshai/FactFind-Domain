CREATE TABLE [dbo].[TFileImport]
(
[FileImportId] [int] NOT NULL IDENTITY(1, 1),
[RefFileImportTypeId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[EntryDate] [datetime] NOT NULL CONSTRAINT [DF_TFileImport_EntryDate] DEFAULT (getdate()),
[DocVersionId] [int] NOT NULL,
[FailedDocVersionId] [int] NULL,
[NumberImported] [int] NOT NULL CONSTRAINT [DF_TFileImport_NumberImported] DEFAULT ((0)),
[IsImported] [int] NOT NULL CONSTRAINT [DF_TFileImport_IsImported] DEFAULT ((0)),
[NumberFailed] [int] NOT NULL CONSTRAINT [DF_TFileImport_NumberFailed] DEFAULT ((0)),
[NumberDuplicates] [int] NOT NULL CONSTRAINT [DF_TFileImport_NumberDuplicates] DEFAULT ((0)),
[RefFileImportStatusId] [int] NOT NULL CONSTRAINT [DF_TFileImport_Status] DEFAULT ((0)),
[ShouldImportDuplicates] [bit] NOT NULL CONSTRAINT [DF_TFileImport_ShouldImportDuplicates] DEFAULT ((0)),
[StatusDescription] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFileImport_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFileImport] ADD CONSTRAINT [PK_TFileImport] PRIMARY KEY CLUSTERED  ([FileImportId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TFileImport] ADD CONSTRAINT [FK_TFileImport_TRefFileImportStatus] FOREIGN KEY ([RefFileImportStatusId]) REFERENCES [dbo].[TRefFileImportStatus] ([RefFileImportStatusId])
GO
ALTER TABLE [dbo].[TFileImport] ADD CONSTRAINT [FK_TFileImport_TRefFileImportType] FOREIGN KEY ([RefFileImportTypeId]) REFERENCES [dbo].[TRefFileImportType] ([RefFileImportTypeId])
GO
