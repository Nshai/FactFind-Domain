CREATE TABLE [dbo].[TFullQuoteLiabilities]
(
[FullQuoteLiabilitiesId] [int] NOT NULL IDENTITY(1, 1),
[FullQuoteId] [int] NOT NULL,
[LiabilitiesId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFullQuoteLiabilities_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFullQuoteLiabilities] ADD CONSTRAINT [PK_TFullQuoteLiabilities] PRIMARY KEY NONCLUSTERED  ([FullQuoteLiabilitiesId])
GO
