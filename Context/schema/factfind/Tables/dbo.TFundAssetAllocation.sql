CREATE TABLE [dbo].[TFundAssetAllocation](
	[FundAssetAllocationId] [int] IDENTITY(1,1) NOT NULL,
	[FundAssetSummaryId] [int] NOT NULL,
	[AtrRefAssetClassId] [int] NOT NULL,
	[PercentageAllocation] [decimal](18, 2) NOT NULL,
	[ConcurrencyId] [int] NOT NULL,
 CONSTRAINT [PK_TFundAssetAllocation] PRIMARY KEY CLUSTERED 
(
	[FundAssetAllocationId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[TFundAssetAllocation] ADD  CONSTRAINT [DF_TFundAssetAllocation_PercentageAllocation]  DEFAULT ((0)) FOR [PercentageAllocation]
GO

ALTER TABLE [dbo].[TFundAssetAllocation] ADD  CONSTRAINT [DF_TFundAssetAllocation_ConcurrencyId]  DEFAULT ((1)) FOR [ConcurrencyId]
GO