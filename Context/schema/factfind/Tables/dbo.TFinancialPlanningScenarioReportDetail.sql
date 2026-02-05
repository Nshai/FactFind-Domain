CREATE TABLE [dbo].[TFinancialPlanningScenarioReportDetail]
(
[FinancialPlanningScenarioReportDetailId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[FinancialPlanningScenarioId] [int] NOT NULL,
[IsRebalance] [varchar] (50) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_TFinancialPlanningScenarioReportDetail_IsRebalance] DEFAULT ((0)),
[StartDate] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[TargetDate] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[TaxWrapper] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[InitialLumpSum] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[MonthlyContribution] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AnnualWithdrawal] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AnnualWithdrawalPercent] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AnnualWithdrawalIncrease] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[IsFinal] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningScenarioReportDetail_ConcurrencyId] DEFAULT ((1)),
[InitialLumpSum2] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[MonthlyContribution2] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AnnualWithdrawal2] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AnnualWithdrawalPercent2] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AnnualWithdrawalIncrease2] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[TaxWrapper2] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RiskProfile] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningScenarioReportDetail] ADD CONSTRAINT [PK_TFinancialPlanningScenarioReportDetail] PRIMARY KEY NONCLUSTERED  ([FinancialPlanningScenarioReportDetailId])
GO
