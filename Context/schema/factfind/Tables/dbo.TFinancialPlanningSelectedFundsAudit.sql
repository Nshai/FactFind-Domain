CREATE TABLE [dbo].[TFinancialPlanningSelectedFundsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningSelectedInvestmentsId] [int] NOT NULL,
[PolicyBusinessFundId] [int] NOT NULL,
[IsAsset] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningSelectedFundsAudit_ConcurrencyId] DEFAULT ((0)),
[FinancialPlanningSelectedFundsId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFinancialPlanningSelectedFundsAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningSelectedFundsAudit] ADD CONSTRAINT [PK_TFinancialPlanningSelectedFundsAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFinancialPlanningSelectedFundsAudit_FinancialPlanningSelectedFundsId_ConcurrencyId] ON [dbo].[TFinancialPlanningSelectedFundsAudit] ([FinancialPlanningSelectedFundsId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
CREATE NONCLUSTERED INDEX [IDX_TFinancialPlanningSelectedFundsRevisedAudit_FinancialPlanningSelectedFundsRevisedId_ConcurrencyId] ON [dbo].[TFinancialPlanningSelectedFundsAudit] ([FinancialPlanningSelectedFundsId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
