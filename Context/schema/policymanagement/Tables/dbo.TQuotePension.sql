CREATE TABLE [dbo].[TQuotePension]
(
[QuotePensionId] [int] NOT NULL IDENTITY(1, 1),
[QuoteItemId] [int] NOT NULL,
[Contribution] [decimal] (18, 0) NULL,
[EmployerContribution] [decimal] (18, 0) NULL,
[RetirementAge] [int] NULL,
[TotalFundValue] [decimal] (18, 0) NULL,
[Pension] [decimal] (18, 0) NULL,
[CashSum] [decimal] (18, 0) NULL,
[ReducedPension] [decimal] (18, 0) NULL,
[MediumGrowthRate] [decimal] (18, 0) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TQuotePension_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TQuotePension] ADD CONSTRAINT [PK_TQuotePension] PRIMARY KEY NONCLUSTERED  ([QuotePensionId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IDX_TQuotePension] ON [dbo].[TQuotePension] ([QuoteItemId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TQuotePension] ADD CONSTRAINT [FK_TQuotePension_QuoteItemId_TQuoteItem] FOREIGN KEY ([QuoteItemId]) REFERENCES [dbo].[TQuoteItem] ([QuoteItemId])
GO
