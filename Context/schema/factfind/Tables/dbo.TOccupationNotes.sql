CREATE TABLE [dbo].[TOccupationNotes]
(
[OccupationNotesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Notes] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TOccupati__Concu__7F6BDA51] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TOccupationNotes_CRMContactId] ON [dbo].[TOccupationNotes] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
