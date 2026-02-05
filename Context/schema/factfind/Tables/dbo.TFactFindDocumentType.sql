CREATE TABLE [dbo].[TFactFindDocumentType]
(
[FactFindDocumentTypeId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFactFindDocumentType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFactFindDocumentType] ADD CONSTRAINT [PK_TFactFindDocumentType] PRIMARY KEY NONCLUSTERED  ([FactFindDocumentTypeId]) WITH (FILLFACTOR=80)
GO
