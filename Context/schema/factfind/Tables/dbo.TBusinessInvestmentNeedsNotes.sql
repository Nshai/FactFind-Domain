CREATE TABLE [dbo].[TBusinessInvestmentNeedsNotes]
(
[BusinessInvestmentNeedsNotesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Notes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TBusinessInvestmentNeedsNotes__ConcurrencyId] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TBusinessInvestmentNeedsNotes_CRMContactId] ON [dbo].[TBusinessInvestmentNeedsNotes] ([CRMContactId])
GO
