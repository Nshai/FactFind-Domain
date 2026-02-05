CREATE TABLE [dbo].[TFundPriceDenorm]
(
[FundUnitId] [int] NOT NULL,
[FundTypeId] [int] NOT NULL,
[Price] [money] NULL,
[PriceDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[TFundPriceDenorm] ADD CONSTRAINT [PK_TFundPriceDenorm] PRIMARY KEY CLUSTERED  ([FundUnitId])
GO

