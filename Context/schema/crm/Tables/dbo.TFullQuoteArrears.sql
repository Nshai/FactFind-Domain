CREATE TABLE [dbo].[TFullQuoteArrears]
(
[FullQuoteArrearsId] [int] NOT NULL IDENTITY(1, 1),
[FullQuoteId] [int] NOT NULL,
[ArrearsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFullQuoteArrears_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFullQuoteArrears] ADD CONSTRAINT [PK_TFullQuoteArrears] PRIMARY KEY NONCLUSTERED  ([FullQuoteArrearsId])
GO
