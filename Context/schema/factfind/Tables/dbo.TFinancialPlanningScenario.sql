CREATE TABLE [dbo].[TFinancialPlanningScenario]
(
[FinancialPlanningScenarioId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[Scenario] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[ScenarioName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RebalanceInvestments] [bit] NOT NULL CONSTRAINT [DF_TFinancialPlanningScenario_RebalanceInvestments] DEFAULT ((0)),
[RefTaxWrapperId] [int] NULL,
[RetirementAge] [int] NULL,
[InitialLumpSum] [money] NULL,
[MonthlyContribution] [money] NULL,
[AnnualWithdrawal] [money] NULL,
[AnnualWithdrawalPercent] [decimal] (18, 2) NULL,
[AnnualWithdrawalIncrease] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[StartDate] [datetime] NULL,
[TargetDate] [datetime] NULL,
[RiskProfile] [uniqueidentifier] NULL,
[AtrPortfolioGUID] [uniqueidentifier] NULL,
[PODGuid] [uniqueidentifier] NULL,
[EvalueXML] [xml] NULL,
[PrefferedScenario] [bit] NOT NULL CONSTRAINT [DF_TFinancialPlanningScenario_PrefferedScenario] DEFAULT ((0)),
[Active] [bit] NOT NULL CONSTRAINT [DF_TFinancialPlanningScenario_Active] DEFAULT ((0)),
[IsReadOnly] [bit] NOT NULL CONSTRAINT [DF_TFinancialPlanningScenario_IsReadOnly] DEFAULT ((0)),
[IsMonthlyModelling] [bit] NOT NULL CONSTRAINT [DF_TFinancialPlanningScenario_IsMonthlyModelling] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningScenario_ConcurrencyId] DEFAULT ((1)),
[InitialLumpSum2] [money] NULL,
[MonthlyContribution2] [money] NULL,
[AnnualWithdrawal2] [money] NULL,
[AnnualWithdrawalPercent2] [decimal] (18, 2) NULL,
[AnnualWithdrawalIncrease2] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RefTaxWrapperId2] [int] NULL,
[RiskProfileId] [int] NULL,
[ProposedSolutionGoalId] [int] NULL,
[ProposalStatus] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[InitialFeePercentage] [decimal] (18, 0) NULL,
[OngoingFeePercentage] [decimal] (18, 0) NULL,
[CreatedDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningScenario] ADD CONSTRAINT [PK_TFinancialPlanningScenario] PRIMARY KEY NONCLUSTERED  ([FinancialPlanningScenarioId])
GO
CREATE NONCLUSTERED INDEX [IX_TFinancialPlanningScenario_FinancialPlanningId_Active] ON [dbo].[TFinancialPlanningScenario] ([FinancialPlanningId], [Active])
GO
CREATE NONCLUSTERED INDEX [IX_TFinancialPlanningScenario_FinancialPlanningId_PrefferedScenario] ON [dbo].[TFinancialPlanningScenario] ([FinancialPlanningId], [PrefferedScenario])
GO
