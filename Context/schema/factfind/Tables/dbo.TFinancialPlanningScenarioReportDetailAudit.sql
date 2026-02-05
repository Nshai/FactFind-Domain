CREATE TABLE [dbo].[TFinancialPlanningScenarioReportDetailAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[FinancialPlanningScenarioId] [int] NOT NULL,
[IsRebalance] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[StartDate] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[TargetDate] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[TaxWrapper] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[InitialLumpSum] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[MonthlyContribution] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AnnualWithdrawal] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AnnualWithdrawalPercent] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AnnualWithdrawalIncrease] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[IsFinal] [bit] NULL,
[ConcurrencyId] [varchar] (50) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_TFinancialPlanningScenarioReportDetailAudit_ConcurrencyId] DEFAULT ((1)),
[FinancialPlanningScenarioReportDetailId] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFinancialPlanningScenarioReportDetailAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningScenarioReportDetailAudit] ADD CONSTRAINT [PK_TFinancialPlanningScenarioReportDetailAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFinancialPlanningScenarioReportDetailAudit_FinancialPlanningScenarioReportDetailId_ConcurrencyId] ON [dbo].[TFinancialPlanningScenarioReportDetailAudit] ([FinancialPlanningScenarioReportDetailId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
