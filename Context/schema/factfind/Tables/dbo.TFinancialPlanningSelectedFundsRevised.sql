CREATE TABLE [dbo].[TFinancialPlanningSelectedFundsRevised]
(
[FinancialPlanningSelectedFundsRevisedId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningSelectedFundsId] [int] NOT NULL,
[PolicyBusinessFundId] [bigint] NOT NULL,
[RevisedValue] [decimal] (18, 2) NULL,
[RevisedPercentage] [decimal] (18, 2) NULL,
[IsLocked] [bit] NULL CONSTRAINT [DF_TFinancialPlanningSelectedFundsRevised_IsLocked] DEFAULT ((0)),
[IsExecuted] [bit] NOT NULL CONSTRAINT [DF_TFinancialPlanningSelectedFundsRevised_IsExecuted] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningSelectedFundsRevised_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TFinancialPlanningSelectedFundsRevised] ADD CONSTRAINT [PK_TFinancialPlanningSelectedFundsRevised] PRIMARY KEY NONCLUSTERED  ([FinancialPlanningSelectedFundsRevisedId])
GO
