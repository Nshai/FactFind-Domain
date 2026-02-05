CREATE TABLE [dbo].[TFinancialPlanningSelectedInvestmentsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[InvestmentId] [int] NOT NULL,
[InvestmentType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningSelectedInvestmentsAudit_ConcurrencyId] DEFAULT ((0)),
[FinancialPlanningSelectedInvestmentsId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFinancialPlanningSelectedInvestmentsAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningSelectedInvestmentsAudit] ADD CONSTRAINT [PK_TFinancialPlanningSelectedInvestmentsAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFinancialPlanningSelectedInvestmentsAudit_FinancialPlanningSelectedInvestmentsId_ConcurrencyId] ON [dbo].[TFinancialPlanningSelectedInvestmentsAudit] ([FinancialPlanningSelectedInvestmentsId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
