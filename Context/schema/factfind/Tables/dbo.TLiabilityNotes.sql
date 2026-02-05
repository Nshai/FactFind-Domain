CREATE TABLE [dbo].[TLiabilityNotes]
(
[LiabilityNotesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[LiabilityNotes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TLiabilit__Concu__34D3C6C9] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TLiabilityNotes_CRMContactId] ON [dbo].[TLiabilityNotes] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
