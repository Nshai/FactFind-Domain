CREATE TABLE [dbo].[TPortfolioFundAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PortfolioId] [int] NOT NULL,
[FundUnitId] [int] NULL,
[EquityId] [int] NULL,
[AllocationPercentage] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_TPortfolioFundAudit_AllocationPercentage] DEFAULT ((0)),
[IsLocked] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPortfolioFundAudit_ConcurrencyId] DEFAULT ((1)),
[PortfolioFundId] [int] NOT NULL,
[UnitId] [varchar](11) NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPortfolioFundAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TPortfolioFundAudit] ADD CONSTRAINT [PK_TPortfolioFundAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPortfolioFundAudit_PortfolioFundId_ConcurrencyId] ON [dbo].[TPortfolioFundAudit] ([PortfolioFundId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
