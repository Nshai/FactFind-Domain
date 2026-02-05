CREATE TABLE [dbo].[TImportTypeMappingColumn]
(
[ImportTypeMappingColumnId] [int] NOT NULL IDENTITY(1, 1),
[ImportTypeId] [int] NOT NULL,
[ColumnName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[DisplayName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[PropertyName] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[IsRequired] [bit] NOT NULL CONSTRAINT [DF_TImportTypeMappingColumn_IsRequired] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TImportTypeMappingColumn_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TImportTypeMappingColumn] ADD CONSTRAINT [PK_TImportTypeMappingColumn] PRIMARY KEY NONCLUSTERED  ([ImportTypeMappingColumnId])
GO
ALTER TABLE [dbo].[TImportTypeMappingColumn] ADD CONSTRAINT [FK_TImportTypeMappingColumn_ImportTypeId_TImportType] FOREIGN KEY ([ImportTypeId]) REFERENCES [dbo].[TImportType] ([ImportTypeId])
GO
