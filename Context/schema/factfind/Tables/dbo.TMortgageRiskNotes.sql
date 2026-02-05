CREATE TABLE [dbo].[TMortgageRiskNotes]
(
[MortgageRiskNotesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[riskComment] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMortgageRiskNotes_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TMortgageRiskNotes] ADD CONSTRAINT [PK_TMortgageRiskNotes] PRIMARY KEY NONCLUSTERED  ([MortgageRiskNotesId])
GO
CREATE NONCLUSTERED INDEX [idx_TMortgageRiskNotes_CRMContactId] ON [dbo].[TMortgageRiskNotes] ([CRMContactId])
GO
