CREATE TABLE [dbo].[TProfileNotes]
(
[ProfileNotesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Notes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TProfileN__Concu__04EFA97D] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TProfileNotes_CRMContactId] ON [dbo].[TProfileNotes] ([CRMContactId])
GO
