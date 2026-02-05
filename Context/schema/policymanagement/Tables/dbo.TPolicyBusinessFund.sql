CREATE TABLE [dbo].[TPolicyBusinessFund]
(
[PolicyBusinessFundId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[FundId] [int] NOT NULL,
[FundTypeId] [int] NULL,
[FundName] [varchar] (255) NULL,
[CategoryId] [int] NULL,
[CategoryName] [varchar] (50) NULL,
[CurrentUnitQuantity] [money] NULL,
[LastUnitChangeDate] [datetime] NULL,
[CurrentPrice] [money] NULL,
[LastPriceChangeDate] [datetime] NULL,
[PriceUpdatedByUser] [varchar] (255) NULL,
[FromFeedFg] [bit] NOT NULL CONSTRAINT [DF_TPolicyBusinessFund_FromFeedFg] DEFAULT ((0)),
[FundIndigoClientId] [int] NULL,
[InvestmentTypeId] [int] NULL,
[RiskRating] [int] NULL,
[EquityFg] [bit] NOT NULL CONSTRAINT [DF_TPolicyBusinessFund_EquityFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyBusinessFund_ConcurrencyId] DEFAULT ((1)),
[UpdatedByReplicatedProc] [bit] NOT NULL CONSTRAINT [DF_TPolicyBusinessFund_UpdatedByFeed] DEFAULT ((0)),
[Cost] [decimal] (28, 4) NULL,
[LastTransactionChangeDate] [datetime] NULL,
[RegularContributionPercentage] [decimal] (18, 5) NOT NULL CONSTRAINT [DF_TPolicyBusinessFund_RegularContributionPercentage] DEFAULT ((0)),
[PortfolioName] [varchar] (255) NULL,
[ModelPortfolioName] [varchar] (2000) NULL,
[DFMName] [varchar] (2000) NULL,
[MigrationReference] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TPolicyBusinessFund] ADD CONSTRAINT [PK_TPolicyBusinessFund] PRIMARY KEY NONCLUSTERED  ([PolicyBusinessFundId])
GO
CREATE CLUSTERED INDEX [CLX_TPolicyBusinessFund_PolicyBusinessId] ON [dbo].[TPolicyBusinessFund] ([PolicyBusinessId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyBusinessFund_FundId] ON [dbo].[TPolicyBusinessFund] ([FundId])
GO
ALTER TABLE [dbo].[TPolicyBusinessFund] WITH CHECK ADD CONSTRAINT [FK_TPolicyBusinessFund_PolicyBusinessId_PolicyBusinessId] FOREIGN KEY ([PolicyBusinessId]) REFERENCES [dbo].[TPolicyBusiness] ([PolicyBusinessId])
GO
ALTER TABLE [dbo].[TPolicyBusinessFund] SET ( LOCK_ESCALATION = DISABLE )
GO