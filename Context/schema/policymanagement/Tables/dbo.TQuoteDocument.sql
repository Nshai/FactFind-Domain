CREATE TABLE [dbo].[TQuoteDocument]
(
[QuoteDocumentId] [int] NOT NULL IDENTITY(1, 1),
[QuoteId] [int] NOT NULL,
[QuoteItemId] [int] NULL,
[DocumentId] [int] NOT NULL,
[DocVersionId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQuoteDocument_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TQuoteDocument] ADD CONSTRAINT [PK_TQuoteDocument] PRIMARY KEY NONCLUSTERED  ([QuoteDocumentId]) WITH (FILLFACTOR=80)
GO
