CREATE TABLE [dbo].[TPortfolioClientAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PortfolioId] [int] NOT NULL,
[CreatedBy] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[CRMContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[PortfolioClientId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TTPortfolioClientAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPortfolioClientAudit] ADD CONSTRAINT [PK_TPortfolioClientAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TPortfolioClientAudit_PortfolioClientId_ConcurrencyId] ON [dbo].[TPortfolioClientAudit] ([PortfolioClientId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
