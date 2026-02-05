CREATE TABLE [dbo].[TQuoteTerm]
(
[QuoteTermId] [int] NOT NULL IDENTITY(1, 1),
[QuoteItemId] [int] NOT NULL,
[PremiumAmount] [money] NULL,
[PremiumType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PremiumIsNet] [bit] NOT NULL CONSTRAINT [DF_TQuoteTerm_PremiumIsNet] DEFAULT ((0)),
[PremiumFrequency] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[CoverAmount] [money] NOT NULL,
[TerminalIllness] [bit] NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TQuoteTerm] ADD CONSTRAINT [PK_TQuoteTerm] PRIMARY KEY NONCLUSTERED  ([QuoteTermId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IDX_TQuoteTerm] ON [dbo].[TQuoteTerm] ([QuoteItemId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TQuoteTerm] ADD CONSTRAINT [FK_TQuoteTerm_QuoteItemId_TQuoteItem] FOREIGN KEY ([QuoteItemId]) REFERENCES [dbo].[TQuoteItem] ([QuoteItemId])
GO
