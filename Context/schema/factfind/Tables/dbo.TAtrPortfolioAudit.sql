CREATE TABLE [dbo].[TAtrPortfolioAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[AtrRefPortfolioTypeId] [int] NULL,
[Active] [bit] NOT NULL,
[AnnualReturn] [decimal] (10, 4) NULL,
[Volatility] [decimal] (10, 4) NULL,
[AtrTemplateGuid] [uniqueidentifier] NOT NULL,
[IndigoClientId] [int] NULL,
[Guid] [uniqueidentifier] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrPortfolioAudit_ConcurrencyId] DEFAULT ((1)),
[AtrPortfolioId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAtrPortfolioAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrPortfolioAudit] ADD CONSTRAINT [PK_TAtrPortfolioAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrPortfolioAudit_AtrPortfolioId_ConcurrencyId] ON [dbo].[TAtrPortfolioAudit] ([AtrPortfolioId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
