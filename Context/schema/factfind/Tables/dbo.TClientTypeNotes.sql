CREATE TABLE [dbo].[TClientTypeNotes]
(
[ClientTypeNotesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[ClientTypeNotes] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TClientTypeNotes__ConcurrencyId] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TClientTypeNotes_CRMContactId] ON [dbo].[TClientTypeNotes] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
