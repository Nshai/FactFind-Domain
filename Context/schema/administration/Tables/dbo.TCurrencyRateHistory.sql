CREATE TABLE [dbo].[TCurrencyRateHistory](
	[CurrencyRateHistoryId] [int] NOT NULL IDENTITY(1, 1),
	[CurrencyCode] [char](3) NOT NULL,
	[Rate] [money] NOT NULL,
	[ProviderName] [varchar](50) NOT NULL,
	[ProviderDate] [date] NOT NULL,
	[StampDateTime] [datetime] NOT NULL
 )
GO
ALTER TABLE [dbo].[TCurrencyRateHistory] ADD CONSTRAINT [PK_TCurrencyRateHistory] PRIMARY KEY CLUSTERED ([ProviderDate], [CurrencyCode])
GO
