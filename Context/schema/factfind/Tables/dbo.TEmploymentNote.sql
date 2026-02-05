CREATE TABLE [dbo].[TEmploymentNote]
(
[EmploymentNoteId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEmploymentNote_ConcurrencyId] DEFAULT ((1)),
[CRMContactId] [int] NOT NULL,
[Note] [varchar] (8000) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEmploymentNote] ADD CONSTRAINT [PK_TEmploymentNote] PRIMARY KEY NONCLUSTERED  ([EmploymentNoteId])
GO
CREATE NONCLUSTERED INDEX [IX_TEmploymentNote_CRMContactId] ON [dbo].[TEmploymentNote] ([CRMContactId])
GO
