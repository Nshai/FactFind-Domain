CREATE TABLE [dbo].[TAtrPortfolioCombinedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AtrPortfolioId] [int] NOT NULL,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[AtrRefPortfolioTypeId] [int] NULL,
[Active] [bit] NOT NULL,
[AnnualReturn] [decimal] (10, 4) NULL,
[Volatility] [decimal] (10, 4) NULL,
[AtrTemplateGuid] [uniqueidentifier] NOT NULL,
[IndigoClientId] [int] NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrPortfolioCombinedAudit_ConcurrencyId] DEFAULT ((1)),
[Guid] [uniqueidentifier] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAtrPortfolioCombinedAudit] ADD CONSTRAINT [PK_TAtrPortfolioCombinedAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrPortfolioCombinedAudit_Guid_ConcurrencyId] ON [dbo].[TAtrPortfolioCombinedAudit] ([Guid], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
