CREATE TABLE [dbo].[TFullQuoteBankruptcy]
(
[FullQuoteBankruptcyId] [int] NOT NULL IDENTITY(1, 1),
[FullQuoteId] [int] NOT NULL,
[BankruptcyId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFullQuoteBankruptcy_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFullQuoteBankruptcy] ADD CONSTRAINT [PK_TFullQuoteBankruptcy] PRIMARY KEY NONCLUSTERED  ([FullQuoteBankruptcyId])
GO
