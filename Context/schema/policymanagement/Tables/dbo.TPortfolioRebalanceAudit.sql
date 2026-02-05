CREATE TABLE [dbo].[TPortfolioRebalanceAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PortfolioClientId] [int] NOT NULL,
[CreatedBy] [int] NOT NULL,
[DateOfRebalance] [datetime] NOT NULL CONSTRAINT [DF_TPortfolioRebalanceAudit_DateOfRebalance] DEFAULT (getdate()),
[IsActioned] [bit] NULL,
[TransactionDate] [datetime] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPortfolioRebalanceAudit_ConcurrencyId] DEFAULT ((1)),
[PortfolioRebalanceId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPortfolioRebalanceAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPortfolioRebalanceAudit] ADD CONSTRAINT [PK_TPortfolioRebalanceAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPortfolioRebalanceAudit_PortfolioRebalanceId_ConcurrencyId] ON [dbo].[TPortfolioRebalanceAudit] ([PortfolioRebalanceId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
