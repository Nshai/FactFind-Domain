CREATE TABLE [dbo].[TFinancialPlanningInvestmentAssetAllocationBreakdown]
(
[FinancialPlanningInvestmentAssetAllocationBreakdownId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningInvestmentAssetAllocationId] [int] NOT NULL,
[AssetClass] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[AllocationPercentage] [money] NOT NULL CONSTRAINT [DF_TFinancialPlanningInvestmentAssetAllocationBreakdown_AllocationPercentage] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningInvestmentAssetAllocationBreakdown_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFinancialPlanningInvestmentAssetAllocationBreakdown] ADD CONSTRAINT [PK_TFinancialPlanningInvestmentAssetAllocationBreakdown] PRIMARY KEY NONCLUSTERED  ([FinancialPlanningInvestmentAssetAllocationBreakdownId])
GO
