CREATE TABLE [dbo].[TFullQuote]
(
[FullQuoteId] [int] NOT NULL IDENTITY(1, 1),
[OpportunityId] [int] NOT NULL,
[FactFindId] [int] NOT NULL,
[SourceDescription] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TFullQuote] ADD CONSTRAINT [PK_TFullQuote] PRIMARY KEY NONCLUSTERED  ([FullQuoteId])
GO
