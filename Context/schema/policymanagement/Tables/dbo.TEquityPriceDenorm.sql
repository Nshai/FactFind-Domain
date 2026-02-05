CREATE TABLE [dbo].[TEquityPriceDenorm]
(
[EquityId] [int] NOT NULL,
[Price] [money] NULL,
[PriceDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[TEquityPriceDenorm] ADD CONSTRAINT [PK_TEquityPriceDenorm] PRIMARY KEY CLUSTERED  ([EquityId])
GO