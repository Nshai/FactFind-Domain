CREATE TABLE [dbo].[TFinancialNotes]
(
[FinancialNotesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[FinancialNotes] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TFinancialNotes__ConcurrencyId] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TFinancialNotes_CRMContactId] ON [dbo].[TFinancialNotes] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
