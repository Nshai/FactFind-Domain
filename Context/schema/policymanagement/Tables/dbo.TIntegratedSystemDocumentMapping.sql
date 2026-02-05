CREATE TABLE [dbo].[TIntegratedSystemDocumentMapping]
(
[IntegratedSystemDocumentMappingId] [int] NOT NULL IDENTITY(1, 1),
[ApplicationLinkId] [int] NOT NULL,
[IsSaveDocuments] [tinyint] NOT NULL CONSTRAINT [DF_TIntegratedSystemDocumentMapping_IsSaveDocuments] DEFAULT ((0)),
[DocumentCategoryId] [int] NULL,
[DocumentSubCategoryId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIntegratedSystemDocumentMapping_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TIntegratedSystemDocumentMapping] ADD CONSTRAINT [PK_TIntegratedSystemDocumentMapping] PRIMARY KEY NONCLUSTERED  ([IntegratedSystemDocumentMappingId])
GO
