CREATE TABLE [dbo].[TCorporateCurrentProtectionNotes]
(
[CorporateCurrentProtectionNotesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Notes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TCorporateCurrentProtectionNotes__ConcurrencyId] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TCorporateCurrentProtectionNotes_CRMContactId] ON [dbo].[TCorporateCurrentProtectionNotes] ([CRMContactId])
GO
