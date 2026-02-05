CREATE TABLE [dbo].[TAtrAssetClassFund]
(
[AtrAssetClassFundId] [int] NOT NULL IDENTITY(1, 1),
[AtrAssetClassGuid] [uniqueidentifier] NOT NULL,
[FundId] [int] NULL,
[FundTypeId] [int] NULL,
[FromFeed] [bit] NOT NULL CONSTRAINT [DF__TAtrAsset__FromF__24341603] DEFAULT ((0)),
[Recommended] [bit] NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrAssetClassFund_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAtrAssetClassFund] ADD CONSTRAINT [PK_TAtrAssetClassFund] PRIMARY KEY NONCLUSTERED  ([AtrAssetClassFundId]) WITH (FILLFACTOR=80)
GO
