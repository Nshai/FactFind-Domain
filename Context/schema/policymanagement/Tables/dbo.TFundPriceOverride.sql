CREATE TABLE [dbo].[TFundPriceOverride]
(
[FundPriceOverrideId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[FundId] [int] NOT NULL,
[FundTypeId] [int] NOT NULL,
[FromFeedFg] [bit] NOT NULL,
[PriceDate] [datetime] NULL,
[Price] [float] NULL,
[PriceUpdatedBy] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFundPriceOverride_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFundPriceOverride] ADD CONSTRAINT [PK_TFundPriceOverride] PRIMARY KEY CLUSTERED  ([FundPriceOverrideId]) WITH (FILLFACTOR=80)
GO
