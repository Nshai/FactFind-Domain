CREATE TABLE [dbo].[TFileImportResult]
(
[FileImportResultId] [int] NOT NULL IDENTITY(1, 1),
[FileImportId] [int] NOT NULL,
[Identifier] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[LineNumber] [int] NOT NULL,
[Descriptor] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[RefFileImportTypeId] [int] NULL,
[Result] [varchar] (16) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFileImportResult_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFileImportResult] ADD CONSTRAINT [PK_TFileImportResult_FileImportResultId] PRIMARY KEY NONCLUSTERED  ([FileImportResultId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TFileImportResult] ADD CONSTRAINT [FK_TFileImportResult_TFileImport] FOREIGN KEY ([FileImportId]) REFERENCES [dbo].[TFileImport] ([FileImportId])
GO
ALTER TABLE [dbo].[TFileImportResult] ADD CONSTRAINT [FK_TFileImportResult_TRefFileImportType] FOREIGN KEY ([RefFileImportTypeId]) REFERENCES [dbo].[TRefFileImportType] ([RefFileImportTypeId])
GO
