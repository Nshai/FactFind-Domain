CREATE TABLE [dbo].[TPortfolioRebalanceFund]
(
[PortfolioRebalanceFundId] [int] NOT NULL IDENTITY(1, 1),
[PortfolioRebalanceId] [int] NOT NULL,
[FundName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[UnitsHeld] [money] NULL,
[Price] [money] NULL,
[Value] [money] NULL,
[TargetPercentage] [decimal] (18, 2) NULL,
[ChangeUnitsHeld] [money] NULL,
[ChangeAmount] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPortfolioRebalanceFund_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPortfolioRebalanceFund] ADD CONSTRAINT [PK_TPortfolioRebalanceFund] PRIMARY KEY NONCLUSTERED  ([PortfolioRebalanceFundId])
GO
