CREATE TABLE [dbo].[TRefRegionalCurrency]
(
	[RegionalCurrencyId] [tinyint] NOT NULL,
	[CurrencyCode] [nchar](3) NOT NULL,
	CONSTRAINT [PK_TRefRegionalCurrency] PRIMARY KEY CLUSTERED ([RegionalCurrencyId]),
	CONSTRAINT [CHK_TRefRegionalCurrency_OneRow] CHECK ([RegionalCurrencyId] = 0)
);
