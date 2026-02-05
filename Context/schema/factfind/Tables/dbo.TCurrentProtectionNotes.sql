CREATE TABLE [dbo].[TCurrentProtectionNotes]
(
[CurrentProtectionNotesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Notes] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TCurrentP__Concu__75AD65ED] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TCurrentProtectionNotes_CRMContactId] ON [dbo].[TCurrentProtectionNotes] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
