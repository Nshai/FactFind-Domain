CREATE TABLE [dbo].[TImportFile]
(
[ImportFileId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[ImportTypeId] [int] NOT NULL,
[PartyId] [int] NOT NULL,
[EntryDate] [datetime] NOT NULL,
[OriginalFileName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[OriginalFilePath] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[FileSize] [int] NULL,
[DocVersionId] [int] NULL,
[ProcessedTimeStamp] [datetime] NULL,
[ProcessStartTimeStamp] [datetime] NULL,
[PotentialImports] [int] NULL,
[NumberImported] [int] NULL,
[NumberFailed] [int] NULL,
[NumberDuplicates] [int] NULL,
[IsDeferred] [bit] NOT NULL CONSTRAINT [DF_TImportFile_IsDeferred] DEFAULT ((0)),
[IsAllowDuplicates] [bit] NOT NULL CONSTRAINT [DF_TImportFile_IsAllowDuplicates] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TImportFile_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TImportFile] ADD CONSTRAINT [PK_TImportFile] PRIMARY KEY NONCLUSTERED  ([ImportFileId])
GO
ALTER TABLE [dbo].[TImportFile] ADD CONSTRAINT [FK_TImportFile_ImportTypeId_TImportType] FOREIGN KEY ([ImportTypeId]) REFERENCES [dbo].[TImportType] ([ImportTypeId])
GO
