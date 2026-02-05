CREATE TABLE [dbo].[TInvestmentneednotes]
(
[InvestmentneednotesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[investmentneednotes] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TInvestme__Concu__2779CBAB] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TInvestmentneednotes_CRMContactId] ON [dbo].[TInvestmentneednotes] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
