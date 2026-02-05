CREATE TABLE [dbo].[TLinkedDocumentAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FactFindTypeId] [int] NOT NULL,
[FolderId] [int] NULL,
[DocumentId] [int] NULL,
[DateLinked] [datetime] NULL,
[LinkedByUserId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLinkedDocumentAudit_ConcurrencyId] DEFAULT ((1)),
[LinkedDocumentId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TLinkedDocumentAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TLinkedDocumentAudit] ADD CONSTRAINT [PK_TLinkedDocumentAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TLinkedDocumentAudit_LinkedDocumentId_ConcurrencyId] ON [dbo].[TLinkedDocumentAudit] ([LinkedDocumentId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
