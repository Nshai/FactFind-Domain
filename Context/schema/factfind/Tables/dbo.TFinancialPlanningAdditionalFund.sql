CREATE TABLE [dbo].[TFinancialPlanningAdditionalFund]
(
[FinancialPlanningAdditionalFundId] [int] NOT NULL IDENTITY(1, 1),
[FundId] [int] NOT NULL,
[FinancialPlanningId] [int] NOT NULL,
[UnitQuantity] [int] NOT NULL,
[UnitPrice] [money] NOT NULL,
[FundDetails] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningAdditionalFund_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFinancialPlanningAdditionalFund] ADD CONSTRAINT [PK_TFinancialPlanningAdditionalFund] PRIMARY KEY NONCLUSTERED  ([FinancialPlanningAdditionalFundId])
GO
