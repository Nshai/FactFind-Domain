CREATE TABLE [dbo].[TFinancialPlanningScenarioAssetAllocation]
(
[FinancialPlanningScenarioAssetAllocationId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[ScenarioId] [int] NOT NULL,
[AssetClass] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[AllocatiionPercentage] [decimal] (18, 2) NOT NULL,
[Colour] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningScenarioAssetAllocation_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFinancialPlanningScenarioAssetAllocation] ADD CONSTRAINT [PK_TFinancialPlanningScenarioAssetAllocation] PRIMARY KEY CLUSTERED  ([FinancialPlanningScenarioAssetAllocationId])
GO
