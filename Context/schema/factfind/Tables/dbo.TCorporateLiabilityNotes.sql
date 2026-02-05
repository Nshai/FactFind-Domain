CREATE TABLE [dbo].[TCorporateLiabilityNotes]
(
[CorporateLiabilityNotesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Notes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TCorporateLiabilityNotes__ConcurrencyId] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TCorporateLiabilityNotes_CRMContactId] ON [dbo].[TCorporateLiabilityNotes] ([CRMContactId])
GO
