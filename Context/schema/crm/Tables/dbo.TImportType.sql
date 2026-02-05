CREATE TABLE [dbo].[TImportType]
(
[ImportTypeId] [int] NOT NULL IDENTITY(1, 1),
[InternalIdentifier] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ImportTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[DTOObjectName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TImportType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TImportType] ADD CONSTRAINT [PK_TImportType] PRIMARY KEY NONCLUSTERED  ([ImportTypeId])
GO
