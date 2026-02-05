CREATE TABLE [dbo].[TGeneralBusinessDetailsNotes]
(
[GeneralBusinessDetailsNotesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Notes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TGeneralBusinessDetailsNotes__ConcurrencyId] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TGeneralBusinessDetailsNotes_CRMContactId] ON [dbo].[TGeneralBusinessDetailsNotes] ([CRMContactId])
GO
