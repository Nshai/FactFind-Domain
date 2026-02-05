CREATE TABLE [dbo].[TPortfolioRebalance]
(
[PortfolioRebalanceId] [int] NOT NULL IDENTITY(1, 1),
[PortfolioClientId] [int] NOT NULL,
[CreatedBy] [int] NOT NULL,
[DateOfRebalance] [datetime] NOT NULL CONSTRAINT [DF_TPortfolioRebalance_DateOfRebalance] DEFAULT (getdate()),
[IsActioned] [bit] NULL,
[TransactionDate] [datetime] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPortfolioRebalance_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPortfolioRebalance] ADD CONSTRAINT [PK_TPortfolioRebalance] PRIMARY KEY NONCLUSTERED  ([PortfolioRebalanceId])
GO
