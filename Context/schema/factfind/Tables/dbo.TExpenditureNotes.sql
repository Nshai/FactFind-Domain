CREATE TABLE [dbo].[TExpenditureNotes]
(
[ExpenditureNotesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Notes] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TExpendit__Concu__127EAEC5] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TExpenditureNotes_CRMContactId] ON [dbo].[TExpenditureNotes] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
