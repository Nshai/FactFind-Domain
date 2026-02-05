CREATE TABLE [dbo].[TAtrPortfolio]
(
[AtrPortfolioId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[AtrRefPortfolioTypeId] [int] NULL,
[Active] [bit] NOT NULL,
[AnnualReturn] [decimal] (10, 4) NULL,
[Volatility] [decimal] (10, 4) NULL,
[AtrTemplateGuid] [uniqueidentifier] NOT NULL,
[IndigoClientId] [int] NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TAtrPortfolio_Guid] DEFAULT (newid()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrPortfolio_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAtrPortfolio] ADD CONSTRAINT [PK_TAtrPortfolio] PRIMARY KEY NONCLUSTERED  ([AtrPortfolioId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TAtrPortfolio_Guid] ON [dbo].[TAtrPortfolio] ([Guid]) WITH (FILLFACTOR=80)
GO
