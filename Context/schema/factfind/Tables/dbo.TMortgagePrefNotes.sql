CREATE TABLE [dbo].[TMortgagePrefNotes]
(
[MortgagePrefNotesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[notes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMortgagePrefNotes_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TMortgagePrefNotes] ADD CONSTRAINT [PK_TMortgagePrefNotes] PRIMARY KEY NONCLUSTERED  ([MortgagePrefNotesId])
GO
CREATE NONCLUSTERED INDEX [idx_TMortgagePrefNotes_CRMContactId] ON [dbo].[TMortgagePrefNotes] ([CRMContactId])
GO
