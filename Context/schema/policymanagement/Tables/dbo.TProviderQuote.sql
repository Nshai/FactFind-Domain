CREATE TABLE [dbo].[TProviderQuote]
(
[ProviderQuoteId] [int] NOT NULL IDENTITY(1, 1),
[QuoteId] [int] NOT NULL,
[RefProductProviderId] [int] NOT NULL,
[ProviderCode] [varchar] (512)  NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TProviderQuote_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TProviderQuote] ADD CONSTRAINT [PK_TProviderQuote] PRIMARY KEY CLUSTERED  ([ProviderQuoteId])
GO
ALTER TABLE [dbo].[TProviderQuote] WITH CHECK ADD CONSTRAINT [FK_TProviderQuote_TQuote] FOREIGN KEY ([QuoteId]) REFERENCES [dbo].[TQuote] ([QuoteId])
GO
