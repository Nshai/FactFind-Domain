CREATE TABLE [dbo].[TLinkedDocument]
(
[LinkedDocumentId] [int] NOT NULL IDENTITY(1, 1),
[FactFindTypeId] [int] NOT NULL,
[FolderId] [int] NULL,
[DocumentId] [int] NULL,
[DateLinked] [datetime] NULL,
[LinkedByUserId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLinkedDocument_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TLinkedDocument] ADD CONSTRAINT [PK_TLinkedDocument] PRIMARY KEY NONCLUSTERED  ([LinkedDocumentId]) WITH (FILLFACTOR=80)
GO
