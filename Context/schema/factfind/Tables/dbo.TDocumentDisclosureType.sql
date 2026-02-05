CREATE TABLE [dbo].[TDocumentDisclosureType]
(
[DocumentDisclosureTypeId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDocumentDisclosureType_ConcurrencyId] DEFAULT ((1)),
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsArchived] [bit] NULL,
[IndigoClientId] [int] NOT NULL,
[DocumentURL] [varchar] (MAX) NULL,
)
GO
ALTER TABLE [dbo].[TDocumentDisclosureType] ADD CONSTRAINT [PK_TDocumentDisclosureType] PRIMARY KEY NONCLUSTERED  ([DocumentDisclosureTypeId])
GO
CREATE NONCLUSTERED INDEX IX_TDocumentDisclosureType_IndigoClientId ON [dbo].[TDocumentDisclosureType] ([IndigoClientId]) 
GO