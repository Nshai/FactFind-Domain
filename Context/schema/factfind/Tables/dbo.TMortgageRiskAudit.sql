CREATE TABLE [dbo].[TMortgageRiskAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[riskInterestChange] [bit] NULL,
[riskMortgRepaid] [bit] NULL,
[riskInvestVehicle] [bit] NULL,
[riskCharge] [bit] NULL,
[riskOverhang] [bit] NULL,
[riskMaxYears] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMortgageRiskAudit_ConcurrencyId] DEFAULT ((1)),
[MortgageRiskId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TMortgageRiskAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TMortgageRiskAudit] ADD CONSTRAINT [PK_TMortgageRiskAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TMortgageRiskAudit_MortgageRiskId_ConcurrencyId] ON [dbo].[TMortgageRiskAudit] ([MortgageRiskId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
