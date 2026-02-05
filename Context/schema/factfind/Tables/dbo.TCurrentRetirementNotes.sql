CREATE TABLE [dbo].[TCurrentRetirementNotes]
(
[CurrentRetirementNotesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Notes] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TCurrentR__Concu__7795AE5F] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TCurrentRetirementNotes_CRMContactId] ON [dbo].[TCurrentRetirementNotes] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
