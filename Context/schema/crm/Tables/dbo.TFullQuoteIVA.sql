CREATE TABLE [dbo].[TFullQuoteIVA]
(
[FullQuoteIVAId] [int] NOT NULL IDENTITY(1, 1),
[FullQuoteId] [int] NOT NULL,
[IVAId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFullQuoteIVA_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFullQuoteIVA] ADD CONSTRAINT [PK_TFullQuoteIVA] PRIMARY KEY NONCLUSTERED  ([FullQuoteIVAId])
GO
