CREATE TABLE [dbo].[TDependantsNotes]
(
[DependantsNotesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[DisabledDependantsYN] [bit] NULL,
[DisabledNotes] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TDependan__Concu__32EB7E57] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TDependantsNotes_CRMContactId] ON [dbo].[TDependantsNotes] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
