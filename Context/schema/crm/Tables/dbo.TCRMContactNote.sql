CREATE TABLE [dbo].[TCRMContactNote]
(
[CRMContactNoteId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Note] [varchar] (8000)  NULL,
[UserId] [int] NULL,
[DateTime] [datetime] NOT NULL,
[IsLatest] [bit] NOT NULL CONSTRAINT [DF_TCRMContactNote_IsLatest] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCRMContactNote_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TCRMContactNote] ADD CONSTRAINT [PK_TCRMContactNote] PRIMARY KEY NONCLUSTERED  ([CRMContactNoteId])
GO
CREATE NONCLUSTERED INDEX [IDX_TCRMContactNote_CRMContactId] ON [dbo].[TCRMContactNote] ([CRMContactId])
GO
ALTER TABLE [dbo].[TCRMContactNote] WITH CHECK ADD CONSTRAINT [FK_TCRMContactNote_CRMContactId_CRMContactId] FOREIGN KEY ([CRMContactId]) REFERENCES [dbo].[TCRMContact] ([CRMContactId])
GO
