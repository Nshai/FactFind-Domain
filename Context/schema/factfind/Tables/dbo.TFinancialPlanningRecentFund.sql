CREATE TABLE [dbo].[TFinancialPlanningRecentFund]
(
[FinancialPlanningRecentFundId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[FundUnitId] [int] NOT NULL,
[DataAdded] [datetime] NOT NULL CONSTRAINT [DF_TFinancialPlanningRecentFund_DataAdded] DEFAULT (getdate()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningRecentFund_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFinancialPlanningRecentFund] ADD CONSTRAINT [PK_TFinancialPlanningRecentFund] PRIMARY KEY NONCLUSTERED  ([FinancialPlanningRecentFundId])
GO
