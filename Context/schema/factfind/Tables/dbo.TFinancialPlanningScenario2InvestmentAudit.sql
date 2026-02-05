CREATE TABLE [dbo].[TFinancialPlanningScenario2InvestmentAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningScenarioId] [int] NOT NULL,
[InvestmentId] [int] NOT NULL,
[InvestmentType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningScenario2InvestmentAudit_ConcurrencyId] DEFAULT ((1)),
[FinancialPlanningScenario2InvestmentId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFinancialPlanningScenario2InvestmentAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningScenario2InvestmentAudit] ADD CONSTRAINT [PK_TFinancialPlanningScenario2InvestmentAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFinancialPlanningScenario2InvestmentAudit_FinancialPlanningScenario2InvestmentId_ConcurrencyId] ON [dbo].[TFinancialPlanningScenario2InvestmentAudit] ([FinancialPlanningScenario2InvestmentId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
