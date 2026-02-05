CREATE TABLE [dbo].[TFullQuoteRepossession]
(
[FullQuoteRepossessionId] [int] NOT NULL IDENTITY(1, 1),
[FullQuoteId] [int] NOT NULL,
[RepossessionId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFullQuoteRepossession_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFullQuoteRepossession] ADD CONSTRAINT [PK_TFullQuoteRepossession] PRIMARY KEY NONCLUSTERED  ([FullQuoteRepossessionId])
GO
