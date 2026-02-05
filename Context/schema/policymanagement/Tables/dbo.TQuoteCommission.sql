CREATE TABLE [dbo].[TQuoteCommission]
(
[QuoteCommissionId] [int] NOT NULL IDENTITY(1, 1),
[QuoteId] [int] NOT NULL,
[InitialPercentage] [decimal] (5, 2) NOT NULL CONSTRAINT [DF_TQuoteCommission_InitialPercentage] DEFAULT ((0.00)),
[RenewalPercentage] [decimal] (5, 2) NOT NULL CONSTRAINT [DF_TQuoteCommission_RenewalPercentage] DEFAULT ((0.00)),
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQuoteCommission_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TQuoteCommission] ADD CONSTRAINT [PK_TQuoteCommission] PRIMARY KEY CLUSTERED  ([QuoteCommissionId])
GO
ALTER TABLE [dbo].[TQuoteCommission] WITH CHECK ADD CONSTRAINT [FK_TQuoteCommission_TQuote] FOREIGN KEY ([QuoteId]) REFERENCES [dbo].[TQuote] ([QuoteId])
GO
