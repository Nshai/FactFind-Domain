CREATE TABLE [dbo].[TRefFileImportType]
(
[RefFileImportTypeId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefFileImportType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefFileImportType] ADD CONSTRAINT [PK_TRefFileImportType] PRIMARY KEY CLUSTERED  ([RefFileImportTypeId])
GO
