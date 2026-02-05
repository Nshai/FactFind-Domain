CREATE TABLE [dbo].[TPortfolioClientPlanAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PortfolioClientId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[PortfolioClientPlanId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPortfolioClientPlanAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPortfolioClientPlanAudit] ADD CONSTRAINT [PK_TPortfolioClientPlanAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPortfolioClientPlanAudit_PortfolioClientPlanId_ConcurrencyId] ON [dbo].[TPortfolioClientPlanAudit] ([PortfolioClientPlanId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
