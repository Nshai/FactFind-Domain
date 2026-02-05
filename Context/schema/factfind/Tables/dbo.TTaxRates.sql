CREATE TABLE [dbo].[TTaxRates]
(
[TaxRatesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[TaxRate] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TTaxRates__Concu__10966653] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TTaxRates_CRMContactId] ON [dbo].[TTaxRates] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
