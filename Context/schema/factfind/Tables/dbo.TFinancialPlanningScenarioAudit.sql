CREATE TABLE [dbo].[TFinancialPlanningScenarioAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[Scenario] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[ScenarioName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RebalanceInvestments] [bit] NULL,
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
[PrefferedScenario] [bit] NOT NULL,
[Active] [bit] NOT NULL,
[IsReadOnly] [bit] NULL,
[IsMonthlyModelling] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningScenarioAudit_ConcurrencyId] DEFAULT ((1)),
[FinancialPlanningScenarioId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFinancialPlanningScenarioAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[InitialLumpSum2] [money] NULL,
[MonthlyContribution2] [money] NULL,
[AnnualWithdrawal2] [money] NULL,
[AnnualWithdrawalPercent2] [money] NULL,
[AnnualWithdrawalIncrease2] [money] NULL,
[RefTaxWrapperId2] [money] NULL,
[RiskProfileId] [int] NULL,
[ProposedSolutionGoalId] [int] NULL,
[ProposalStatus] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[InitialFeePercentage] [decimal] (18, 0) NULL,
[OngoingFeePercentage] [decimal] (18, 0) NULL,
[CreatedDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningScenarioAudit] ADD CONSTRAINT [PK_TFinancialPlanningScenarioAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFinancialPlanningScenarioAudit_FinancialPlanningScenarioId_ConcurrencyId] ON [dbo].[TFinancialPlanningScenarioAudit] ([FinancialPlanningScenarioId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
