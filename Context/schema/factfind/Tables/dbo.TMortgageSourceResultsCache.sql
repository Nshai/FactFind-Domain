CREATE TABLE [dbo].[TMortgageSourceResultsCache]
(
[OpportunityId] [int] NOT NULL,
[FullQuoteId] [int] NOT NULL,
[QuoteId] [int] NOT NULL,
[FactFindId] [int] NOT NULL,
[CompressedResults] [varchar] (max) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[TMortgageSourceResultsCache] ADD CONSTRAINT [PK_TMortgageSourceResultsCache ] PRIMARY KEY NONCLUSTERED  ([OpportunityId], [FullQuoteId])
GO
