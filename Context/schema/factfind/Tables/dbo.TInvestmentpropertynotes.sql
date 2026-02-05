CREATE TABLE [dbo].[TInvestmentpropertynotes]
(
[InvestmentpropertynotesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[investmentpropertynotes] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TInvestme__Concu__2962141D] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TInvestmentpropertynotes_CRMContactId] ON [dbo].[TInvestmentpropertynotes] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
