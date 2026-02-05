CREATE TABLE [dbo].[TPortfolioFund]
(
[PortfolioFundId] [int] NOT NULL IDENTITY(1, 1),
[PortfolioId] [int] NOT NULL,
[FundUnitId] [int] NULL,
[EquityId] [int] NULL,
[AllocationPercentage] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_TPortfolioFund_AllocationPercentage] DEFAULT ((0)),
[IsLocked] [bit] NOT NULL CONSTRAINT [DF_TPortfolioFund_IsLocked] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPortfolioFund_ConcurrencyId] DEFAULT ((1)),
[PreferredCodeType] [varchar](10) NULL,
[UnitId] [varchar](11) NULL
)
GO
ALTER TABLE [dbo].[TPortfolioFund] ADD CONSTRAINT [PK_TPortfolioFund] PRIMARY KEY NONCLUSTERED  ([PortfolioFundId])
GO
