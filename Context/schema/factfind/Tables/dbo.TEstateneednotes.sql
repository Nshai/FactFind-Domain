CREATE TABLE [dbo].[TEstateneednotes]
(
[EstateneednotesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[estateneednotes] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TEstatene__Concu__2B4A5C8F] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TEstateneednotes_CRMContactId] ON [dbo].[TEstateneednotes] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
