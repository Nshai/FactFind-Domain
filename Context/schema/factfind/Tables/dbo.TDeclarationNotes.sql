CREATE TABLE [dbo].[TDeclarationNotes]
(
[DeclarationNotesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[DeclarationNotes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDeclarationNotes_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TDeclarationNotes] ADD CONSTRAINT [PK_TDeclarationNotes] PRIMARY KEY NONCLUSTERED  ([DeclarationNotesId])
GO
CREATE NONCLUSTERED INDEX [idx_TDeclarationNotes_CRMContactId] ON [dbo].[TDeclarationNotes] ([CRMContactId])
GO
