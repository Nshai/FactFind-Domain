CREATE TABLE [dbo].[TQuotePHI]
(
[QuotePHIId] [int] NOT NULL IDENTITY(1, 1),
[QuoteItemId] [int] NOT NULL,
[Premium] [decimal] (10, 2) NULL,
[PremiumIncrease] [decimal] (10, 2) NULL,
[CoverPeriod] [int] NULL,
[DeferredPeriod] [int] NULL,
[Benefit] [decimal] (10, 2) NULL,
[Salary] [decimal] (10, 2) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQuotePHI_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TQuotePHI] ADD CONSTRAINT [PK_TQuotePHI] PRIMARY KEY NONCLUSTERED  ([QuotePHIId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IDX_TQuotePHI] ON [dbo].[TQuotePHI] ([QuoteItemId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TQuotePHI] ADD CONSTRAINT [FK_TQuotePHI_QuoteItemId_TQuoteItem] FOREIGN KEY ([QuoteItemId]) REFERENCES [dbo].[TQuoteItem] ([QuoteItemId])
GO
