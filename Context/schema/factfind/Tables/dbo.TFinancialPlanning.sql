CREATE TABLE [dbo].[TFinancialPlanning]
(
[FinancialPlanningId] [int] NOT NULL IDENTITY(1, 1),
[FactFindId] [int] NOT NULL,
[AdjustValue] [bit] NOT NULL CONSTRAINT [DF_TFinancialPlanning_AdjustValue] DEFAULT ((1)),
[RefPlanningTypeId] [int] NOT NULL,
[RefInvestmentTypeId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanning_RefInvestmentTypeId] DEFAULT ((1)),
[IncludeAssets] [bit] NOT NULL CONSTRAINT [DF_TFinancialPlanning_IncludeAssets] DEFAULT ((0)),
[RegularImmediateIncome] [bit] NOT NULL CONSTRAINT [DF_TFinancialPlanning_RegularImmediateIncome] DEFAULT ((0)),
[IsArchived] [bit] NOT NULL CONSTRAINT [DF_TFinancialPlanning_IsArchived] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanning_ConcurrencyId] DEFAULT ((0)),
[GoalType] [int] NULL,
[RefLumpSumAtRetirementTypeId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanning_RefLumpSumAtRetirementType] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFinancialPlanning] ADD CONSTRAINT [PK_TFinancialPlanning] PRIMARY KEY NONCLUSTERED  ([FinancialPlanningId])
GO
