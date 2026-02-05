CREATE TABLE [dbo].[TAtrRefPortfolioType]
(
[AtrRefPortfolioTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Custom] [bit] NULL,
[IsModelPortfolios] [bit] NULL CONSTRAINT [DF_TAtrRefPortfolioType_IsModelPortfolios] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAtrRefPortfolioType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAtrRefPortfolioType] ADD CONSTRAINT [PK_TAtrRefPortfolioType] PRIMARY KEY NONCLUSTERED  ([AtrRefPortfolioTypeId]) WITH (FILLFACTOR=80)
GO
