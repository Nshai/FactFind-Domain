CREATE TABLE [dbo].[TAuthorisedcompanyprofessionalsNotes]
(
[AuthorisedcompanyprofessionalsNotesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Notes] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TAuthoris__Concu__6E0C4425] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TAuthorisedcompanyprofessionalsNotes_CRMContactId] ON [dbo].[TAuthorisedcompanyprofessionalsNotes] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
