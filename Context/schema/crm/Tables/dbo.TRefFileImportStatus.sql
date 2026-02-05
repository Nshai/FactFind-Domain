CREATE TABLE [dbo].[TRefFileImportStatus]
(
[RefFileImportStatusId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TRefFileImportStatus_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefFileImportStatus] ADD CONSTRAINT [PK_FileImportStatus] PRIMARY KEY CLUSTERED  ([RefFileImportStatusId])
GO
