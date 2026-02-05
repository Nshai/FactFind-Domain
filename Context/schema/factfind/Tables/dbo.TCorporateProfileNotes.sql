CREATE TABLE [dbo].[TCorporateProfileNotes]
(
[CorporateProfileNotesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Notes] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCorporateProfileNotes_ConcurrencyId] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TCorporateProfileNotes_CRMContactId] ON [dbo].[TCorporateProfileNotes] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
