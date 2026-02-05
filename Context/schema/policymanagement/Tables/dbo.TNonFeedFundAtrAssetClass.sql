CREATE TABLE [dbo].[TNonFeedFundAtrAssetClass]
(
[NonFeedFundAtrAssetClassId] [int] NOT NULL IDENTITY(1, 1),
[NonFeedFundId] [int] NOT NULL,
[Recommended] [bit] NULL,
[TenantId] [int] NOT NULL,
[AtrRefAssetClassId] [int] NULL,
[Allocation] [decimal] (5, 2) NULL,
[IsEquity] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_Concurrency] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TNonFeedFundAtrAssetClass] ADD CONSTRAINT [PK_TNonFeedFundAtrAssetClass] PRIMARY KEY CLUSTERED  ([NonFeedFundAtrAssetClassId])
GO

CREATE NONCLUSTERED INDEX IX_TNonFeedFundAtrAssetClass_NonFeedFundId   
	ON [dbo].[TNonFeedFundAtrAssetClass] (NonFeedFundId)
GO
	  
CREATE NONCLUSTERED INDEX IX_TNonFeedFundAtrAssetClass_TenantId   
	ON [dbo].[TNonFeedFundAtrAssetClass] (TenantId)
GO
