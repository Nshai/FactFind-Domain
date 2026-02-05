CREATE TABLE [dbo].[TFinancialPlanningScenarioAssetSplits]
(
[FinancialPlanningScenarioAssetSplitsId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[ScenarioId] [int] NOT NULL,
[Cash] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_TFinancialPlanningScenarioAssetSplits_Cash] DEFAULT ((0)),
[Property] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_TFinancialPlanningScenarioAssetSplits_Property] DEFAULT ((0)),
[FixedInterest] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_TFinancialPlanningScenarioAssetSplits_FixedInterest] DEFAULT ((0)),
[UKEquity] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_TFinancialPlanningScenarioAssetSplits_UKEquity] DEFAULT ((0)),
[OverseasEquity] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_TFinancialPlanningScenarioAssetSplits_OverseasEquity] DEFAULT ((0)),
[SpecialistEquity] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_TFinancialPlanningScenarioAssetSplits_SpecialistEquity] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningScenarioAssetSplits_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFinancialPlanningScenarioAssetSplits] ADD CONSTRAINT [PK_TFinancialPlanningScenarioAssetSplits] PRIMARY KEY NONCLUSTERED  ([FinancialPlanningScenarioAssetSplitsId])
GO
