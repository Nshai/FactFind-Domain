CREATE TABLE [dbo].[TPolicyBusinessNote]
(
[PolicyBusinessNoteId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[Note] [varchar] (8000) COLLATE Latin1_General_CI_AS NULL,
[UserId] [int] NULL,
[DateTime] [datetime] NOT NULL,
[IsLatest] [bit] NOT NULL CONSTRAINT [DF_TPolicyBusinessNote_IsLatest] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyBus_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPolicyBusinessNote] ADD CONSTRAINT [PK_TPolicyBusinessNote_PolicyBusinessNoteId] PRIMARY KEY NONCLUSTERED  ([PolicyBusinessNoteId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TPolicyBusinessNote_PolicyBusinessId] ON [dbo].[TPolicyBusinessNote] ([PolicyBusinessId]) WITH (FILLFACTOR=80)
GO
