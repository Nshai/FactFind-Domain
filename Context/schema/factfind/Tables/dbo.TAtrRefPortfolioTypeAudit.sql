CREATE TABLE [dbo].[TAtrRefPortfolioTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Custom] [bit] NULL,
[IsModelPortfolios] [bit] NULL CONSTRAINT [DF_TAtrRefPortfolioTypeAudit_IsModelPortfolios] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrRefPortfolioTypeAudit_ConcurrencyId] DEFAULT ((1)),
[AtrRefPortfolioTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrRefPortfolioTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrRefPortfolioTypeAudit] ADD CONSTRAINT [PK_TAtrRefPortfolioTypeAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrRefPortfolioTypeAudit_AtrRefPortfolioTypeId_ConcurrencyId] ON [dbo].[TAtrRefPortfolioTypeAudit] ([AtrRefPortfolioTypeId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
