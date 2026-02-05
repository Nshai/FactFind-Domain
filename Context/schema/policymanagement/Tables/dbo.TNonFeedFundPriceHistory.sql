CREATE TABLE [dbo].[TNonFeedFundPriceHistory]
(
[NonFeedFundId] [int] NOT NULL,
[Price] [money] NOT NULL,
[PriceDate] [date] NOT NULL
)
GO
ALTER TABLE [dbo].[TNonFeedFundPriceHistory] ADD CONSTRAINT [PK_TNonFeedFundPriceHistory] PRIMARY KEY CLUSTERED ([NonFeedFundId], [PriceDate])
GO
