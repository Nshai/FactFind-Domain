CREATE TABLE [dbo].[TAtrRefPortfolioTypeAssetClass]
(
[AtrRefPortfolioTypeAssetClassId] [int] NOT NULL IDENTITY(1, 1),
[AtrRefPortfolioTypeId] [int] NOT NULL,
[AtrRefAssetClassId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrRefPortfolioTypeAssetClass_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAtrRefPortfolioTypeAssetClass] ADD CONSTRAINT [PK_TAtrRefPortfolioTypeAssetClass] PRIMARY KEY NONCLUSTERED  ([AtrRefPortfolioTypeAssetClassId]) WITH (FILLFACTOR=80)
GO
