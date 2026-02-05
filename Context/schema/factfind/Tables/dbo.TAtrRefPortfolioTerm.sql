CREATE TABLE [dbo].[TAtrRefPortfolioTerm]
(
[AtrRefPortfolioTermId] [int] NOT NULL IDENTITY(1, 1),
[Term] [tinyint] NULL,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrRefPortfolioTerm_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAtrRefPortfolioTerm] ADD CONSTRAINT [PK_TAtrRefPortfolioTerm] PRIMARY KEY NONCLUSTERED  ([AtrRefPortfolioTermId]) WITH (FILLFACTOR=80)
GO
