CREATE TABLE [dbo].[TFinancialPlanningInvestmentAssetAllocationBreakdownAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningInvestmentAssetAllocationId] [int] NOT NULL,
[AssetClass] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[AllocationPercentage] [money] NOT NULL CONSTRAINT [DF_TFinancialPlanningInvestmentAssetAllocationBreakdownAudit_AllocationPercentage] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningInvestmentAssetAllocationBreakdownAudit_ConcurrencyId] DEFAULT ((1)),
[FinancialPlanningInvestmentAssetAllocationBreakdownId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFinancialPlanningInvestmentAssetAllocationBreakdownAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningInvestmentAssetAllocationBreakdownAudit] ADD CONSTRAINT [PK_TFinancialPlanningInvestmentAssetAllocationBreakdownAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFinancialPlanningInvestmentAssetAllocationBreakdownAudit_BreakdownId_ConcurrencyId] ON [dbo].[TFinancialPlanningInvestmentAssetAllocationBreakdownAudit] ([FinancialPlanningInvestmentAssetAllocationBreakdownId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
