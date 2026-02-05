CREATE TABLE [dbo].[TFinancialPlanningInvestmentAssetAllocation]
(
[FinancialPlanningInvestmentAssetAllocationId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[InvestmentId] [int] NOT NULL,
[InvestmentType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Cash] [money] NULL CONSTRAINT [DF_TFinancialPlanningInvestmentAssetAllocation_Cash] DEFAULT ((0)),
[Property] [money] NULL CONSTRAINT [DF_TFinancialPlanningInvestmentAssetAllocation_Property] DEFAULT ((0)),
[FixedInterest] [money] NULL CONSTRAINT [DF_TFinancialPlanningInvestmentAssetAllocation_FixedInterest] DEFAULT ((0)),
[UKEquities] [money] NULL CONSTRAINT [DF_TFinancialPlanningInvestmentAssetAllocation_UKEquities] DEFAULT ((0)),
[OverseasEquities] [money] NULL CONSTRAINT [DF_TFinancialPlanningInvestmentAssetAllocation_OverseasEquities] DEFAULT ((0)),
[SpecialistEquities] [money] NULL CONSTRAINT [DF_TFinancialPlanningInvestmentAssetAllocation_SpecialistEquities] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningInvestmentAssetAllocation_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFinancialPlanningInvestmentAssetAllocation] ADD CONSTRAINT [PK_TFinancialPlanningInvestmentAssetAllocation] PRIMARY KEY NONCLUSTERED  ([FinancialPlanningInvestmentAssetAllocationId])
GO
