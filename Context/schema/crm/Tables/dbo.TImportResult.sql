CREATE TABLE [dbo].[TImportResult]
(
[ImportResultId] [int] NOT NULL IDENTITY(1, 1),
[ImportFileId] [int] NOT NULL,
[LineNumber] [int] NULL,
[Descriptor] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[Result] [bit] NULL,
[IOEntityTypeId] [int] NULL,
[EntityId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TImportResult_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TImportResult] ADD CONSTRAINT [PK_TImportResult] PRIMARY KEY NONCLUSTERED  ([ImportResultId])
GO
ALTER TABLE [dbo].[TImportResult] ADD CONSTRAINT [FK_TImportResult_ImportFileId_TImportFile] FOREIGN KEY ([ImportFileId]) REFERENCES [dbo].[TImportFile] ([ImportFileId])
GO
ALTER TABLE [dbo].[TImportResult] ADD CONSTRAINT [FK_TImportResult_IOEntityTypeId_TIOEntityType] FOREIGN KEY ([IOEntityTypeId]) REFERENCES [dbo].[TIOEntityType] ([IOEntityTypeId])
GO
