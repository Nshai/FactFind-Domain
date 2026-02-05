CREATE TABLE [dbo].[TIncomenotes]
(
[IncomenotesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[incnotes] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TIncomeno__Concu__25918339] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TIncomenotes_CRMContactId] ON [dbo].[TIncomenotes] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
