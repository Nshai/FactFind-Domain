CREATE TABLE [dbo].[TAtrRefPortfolioTermAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Term] [tinyint] NULL,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrRefPortfolioTermAudit_ConcurrencyId] DEFAULT ((1)),
[AtrRefPortfolioTermId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrRefPortfolioTermAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrRefPortfolioTermAudit] ADD CONSTRAINT [PK_TAtrRefPortfolioTermAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrRefPortfolioTermAudit_AtrRefPortfolioTermId_ConcurrencyId] ON [dbo].[TAtrRefPortfolioTermAudit] ([AtrRefPortfolioTermId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
