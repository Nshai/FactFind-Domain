CREATE TABLE [dbo].[TBusinessInvestmentNeedNote]
(
[BusinessInvestmentNeedNoteId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Notes] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TBusiness__Concu__73C51D7B] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TBusinessInvestmentNeedNote_CRMContactId] ON [dbo].[TBusinessInvestmentNeedNote] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
