CREATE TABLE [dbo].[TQuoteWOL]
(
[QuoteWOLId] [int] NOT NULL IDENTITY(1, 1),
[QuoteItemId] [int] NOT NULL,
[CoverBasis] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[CoverRequested] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[QuotationBasis] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[SumAssured] [decimal] (10, 2) NULL,
[Premium] [decimal] (10, 2) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQuoteWOL_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TQuoteWOL] ADD CONSTRAINT [PK_TQuoteWOL] PRIMARY KEY NONCLUSTERED  ([QuoteWOLId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IDX_TQuoteWOL] ON [dbo].[TQuoteWOL] ([QuoteItemId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TQuoteWOL] ADD CONSTRAINT [FK_TQuoteWOL_QuoteItemId_TQuoteItem] FOREIGN KEY ([QuoteItemId]) REFERENCES [dbo].[TQuoteItem] ([QuoteItemId])
GO
