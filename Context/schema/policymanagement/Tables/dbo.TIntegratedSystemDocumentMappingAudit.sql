CREATE TABLE [dbo].[TIntegratedSystemDocumentMappingAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ApplicationLinkId] [int] NOT NULL,
[IsSaveDocuments] [tinyint] NOT NULL CONSTRAINT [DF_TIntegratedSystemDocumentMappingAudit_IsSaveDocuments] DEFAULT ((0)),
[DocumentCategoryId] [int] NULL,
[DocumentSubCategoryId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIntegratedSystemDocumentMappingAudit_ConcurrencyId] DEFAULT ((1)),
[IntegratedSystemDocumentMappingId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TIntegratedSystemDocumentMappingAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TIntegratedSystemDocumentMappingAudit] ADD CONSTRAINT [PK_TIntegratedSystemDocumentMappingAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TIntegratedSystemDocumentMappingAudit_IntegratedSystemDocumentMappingId_ConcurrencyId] ON [dbo].[TIntegratedSystemDocumentMappingAudit] ([IntegratedSystemDocumentMappingId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
