CREATE TABLE [dbo].[TFinancialPlanningRecentFundAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[FundUnitId] [int] NOT NULL,
[DataAdded] [datetime] NOT NULL CONSTRAINT [DF_TFinancialPlanningRecentFundAudit_DataAdded] DEFAULT (getdate()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningRecentFundAudit_ConcurrencyId] DEFAULT ((1)),
[FinancialPlanningRecentFundId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFinancialPlanningRecentFundAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningRecentFundAudit] ADD CONSTRAINT [PK_TFinancialPlanningRecentFundAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFinancialPlanningRecentFundAudit_FinancialPlanningRecentFundId_ConcurrencyId] ON [dbo].[TFinancialPlanningRecentFundAudit] ([FinancialPlanningRecentFundId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
