CREATE TABLE [dbo].[TEquityReleaseNotes]
(
[EquityReleaseNotesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[AdditionalNotes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEquityReleaseNotes_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEquityReleaseNotes] ADD CONSTRAINT [PK_TEquityReleaseNotes] PRIMARY KEY NONCLUSTERED  ([EquityReleaseNotesId])
GO
CREATE NONCLUSTERED INDEX [idx_TEquityReleaseNotes_CRMContactId] ON [dbo].[TEquityReleaseNotes] ([CRMContactId])
GO
