CREATE TABLE [dbo].[TQuoteDocumentAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[QuoteId] [int] NOT NULL,
[QuoteItemId] [int] NULL,
[DocumentId] [int] NOT NULL,
[DocVersionId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQuoteDocumentAudit_ConcurrencyId] DEFAULT ((1)),
[QuoteDocumentId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TQuoteDocumentAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TQuoteDocumentAudit] ADD CONSTRAINT [PK_TQuoteDocumentAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TQuoteDocumentAudit_QuoteDocumentId_ConcurrencyId] ON [dbo].[TQuoteDocumentAudit] ([QuoteDocumentId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
