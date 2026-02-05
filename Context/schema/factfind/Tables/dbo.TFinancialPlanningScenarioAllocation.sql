CREATE TABLE [dbo].[TFinancialPlanningScenarioAllocation]
(
[FinancialPlanningScenarioAllocationId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[ScenarioId] [int] NOT NULL,
[AssetName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[AssetPercentage] [decimal] (18, 2) NOT NULL,
[AssetColour] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[IsFinal] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningScenarioAllocation_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFinancialPlanningScenarioAllocation] ADD CONSTRAINT [PK_TFinancialPlanningScenarioAllocation] PRIMARY KEY CLUSTERED  ([FinancialPlanningScenarioAllocationId])
GO
