CREATE TABLE [dbo].[TPortfolioClientPlan]
(
[PortfolioClientPlanId] [int] NOT NULL IDENTITY(1, 1),
[PortfolioClientId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPortfolioClientPlan_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPortfolioClientPlan] ADD CONSTRAINT [PK_TPortfolioClientPlan] PRIMARY KEY NONCLUSTERED  ([PortfolioClientPlanId])
GO
