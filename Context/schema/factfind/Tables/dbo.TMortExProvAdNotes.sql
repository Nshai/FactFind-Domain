CREATE TABLE [dbo].[TMortExProvAdNotes]
(
[MortExProvAdNotesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[AdditionalNotes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMortExProvAdNotes_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TMortExProvAdNotes] ADD CONSTRAINT [PK_TMortExProvAdNotes] PRIMARY KEY NONCLUSTERED  ([MortExProvAdNotesId])
GO
CREATE NONCLUSTERED INDEX [idx_TMortExProvAdNotes_CRMContactId] ON [dbo].[TMortExProvAdNotes] ([CRMContactId])
GO
