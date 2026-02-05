CREATE TABLE [dbo].[TImportFileMapping]
(
[ImportFileMappingId] [int] NOT NULL IDENTITY(1, 1),
[ImportFileId] [int] NOT NULL,
[ColumnName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ImportTypeMappingColumnId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TImportFileMapping_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TImportFileMapping] ADD CONSTRAINT [PK_TImportFileMapping] PRIMARY KEY NONCLUSTERED  ([ImportFileMappingId])
GO
ALTER TABLE [dbo].[TImportFileMapping] ADD CONSTRAINT [FK_TImportFileMapping_ImportTypeMappingColumnId_TImportTypeMappingColumn] FOREIGN KEY ([ImportTypeMappingColumnId]) REFERENCES [dbo].[TImportTypeMappingColumn] ([ImportTypeMappingColumnId])
GO
