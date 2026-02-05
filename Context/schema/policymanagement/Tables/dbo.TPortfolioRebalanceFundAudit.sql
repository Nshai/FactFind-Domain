CREATE TABLE [dbo].[TPortfolioRebalanceFundAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PortfolioRebalanceId] [int] NOT NULL,
[FundName] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[UnitsHeld] [money] NULL,
[Price] [money] NULL,
[Value] [money] NULL,
[TargetPercentage] [decimal] (18, 2) NULL,
[ChangeUnitsHeld] [money] NULL,
[ChangeAmount] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPortfolioRebalanceFundAudit_ConcurrencyId] DEFAULT ((1)),
[PortfolioRebalanceFundId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPortfolioRebalanceFundAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPortfolioRebalanceFundAudit] ADD CONSTRAINT [PK_TPortfolioRebalanceFundAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPortfolioRebalanceFundAudit_PortfolioRebalanceFundsId_ConcurrencyId] ON [dbo].[TPortfolioRebalanceFundAudit] ([PortfolioRebalanceFundId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
