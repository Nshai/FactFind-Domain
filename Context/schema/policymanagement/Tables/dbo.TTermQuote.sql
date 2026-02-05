CREATE TABLE [dbo].[TTermQuote]
(
[TermQuoteId] [int] NOT NULL IDENTITY(1, 1),
[QuoteId] [int] NOT NULL,
[ProductTermId] [int] NULL,
[QuotationBasisId] [int] NULL,
[QuotePremiumId] [int] NULL,
[LivesAssuredBasis] [varchar] (50)  NULL,
[IncludeRenewable] [bit] NOT NULL CONSTRAINT [DF_TTermQuote_IncludeRenewable] DEFAULT ((0)),
[IncludeBusinessProtectionLevel] [bit] NOT NULL CONSTRAINT [DF_TTermQuote_IncludeBusinessProtectionLevel] DEFAULT ((0)),
[IncludeBusinessProtectionDecreasing] [bit] NOT NULL CONSTRAINT [DF_TTermQuote_IncludeBusinessProtectionDecreasing] DEFAULT ((0)),
[MortgageInterestRate] [decimal] (5, 2) NOT NULL CONSTRAINT [DF_TTermQuote_MortgageInterestRate] DEFAULT ((0.00)),
[PolicyInterestRate] [decimal] (5, 2) NOT NULL CONSTRAINT [DF_TTermQuote_PolicyInterestRate] DEFAULT ((0.00)),
[PremiumWaiverRequired] [bit] NOT NULL CONSTRAINT [DF_TTermQuote_PremiumWaiverRequired] DEFAULT ((0)),
[IncludeTerminalIllness] [bit] NOT NULL CONSTRAINT [DF_TTermQuote_IncludeTerminalIllness] DEFAULT ((0)),
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TTermQuote_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TTermQuote] ADD CONSTRAINT [PK_TTermQuote] PRIMARY KEY CLUSTERED  ([TermQuoteId])
GO
CREATE NONCLUSTERED INDEX [IX_TTermQuote_QuoteId] ON [dbo].[TTermQuote] ([QuoteId])
GO
ALTER TABLE [dbo].[TTermQuote] WITH CHECK ADD CONSTRAINT [FK_TTermQuote_TQuote] FOREIGN KEY ([QuoteId]) REFERENCES [dbo].[TQuote] ([QuoteId])
GO
