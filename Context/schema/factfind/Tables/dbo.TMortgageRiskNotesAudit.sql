CREATE TABLE [dbo].[TMortgageRiskNotesAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[riskComment] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMortgageRiskNotesAudit_ConcurrencyId] DEFAULT ((1)),
[MortgageRiskNotesId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TMortgageRiskNotesAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TMortgageRiskNotesAudit] ADD CONSTRAINT [PK_TMortgageRiskNotesAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TMortgageRiskNotesAudit_MortgageRiskNotesId_ConcurrencyId] ON [dbo].[TMortgageRiskNotesAudit] ([MortgageRiskNotesId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
