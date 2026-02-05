CREATE TABLE [dbo].[TFinancialPlanningSelectedFundsRevisedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningSelectedFundsId] [int] NOT NULL,
[PolicyBusinessFundId] [bigint] NOT NULL,
[RevisedValue] [decimal] (18, 2) NULL,
[RevisedPercentage] [decimal] (18, 2) NULL,
[IsLocked] [bit] NULL,
[IsExecuted] [bit] NOT NULL CONSTRAINT [DF_TFinancialPlanningSelectedFundsRevisedAudit_IsExecuted] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningSelectedFundsRevisedAudit_ConcurrencyId] DEFAULT ((0)),
[FinancialPlanningSelectedFundsRevisedId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFinancialPlanningSelectedFundsRevisedAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningSelectedFundsRevisedAudit] ADD CONSTRAINT [PK_TFinancialPlanningSelectedFundsRevisedAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
