CREATE TABLE [dbo].[TQuoteBond]
(
[QuoteBondId] [int] NOT NULL IDENTITY(1, 1),
[QuoteItemId] [int] NOT NULL,
[InvestmentAmount] [decimal] (10, 2) NULL,
[Term] [int] NULL,
[FinalCIV] [decimal] (10, 2) NULL,
[NumFreeSwitches] [int] NULL,
[MedGrowthRate] [decimal] (10, 2) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQuoteBond_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TQuoteBond] ADD CONSTRAINT [PK_TQuoteBond] PRIMARY KEY NONCLUSTERED  ([QuoteBondId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IDX_TQuoteBond] ON [dbo].[TQuoteBond] ([QuoteItemId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TQuoteBond] ADD CONSTRAINT [FK_TQuoteBond_QuoteItemId_TQuoteItem] FOREIGN KEY ([QuoteItemId]) REFERENCES [dbo].[TQuoteItem] ([QuoteItemId])
GO
