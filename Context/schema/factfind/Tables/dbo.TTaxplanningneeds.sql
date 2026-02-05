CREATE TABLE [dbo].[TTaxplanningneeds]
(
[TaxplanningneedsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[giftsofCapitalYN] [bit] NULL,
[giftsofCapitalCurrentPreviousYN] [bit] NULL,
[giftsOutOfIncomeYN] [bit] NULL,
[potentialIHTValue] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TTaxplann__Concu__36BC0F3B] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TTaxplanningneeds_CRMContactId] ON [dbo].[TTaxplanningneeds] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
