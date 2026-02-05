CREATE TABLE [dbo].[TMortgageRisk]
(
[MortgageRiskId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[riskInterestChange] [bit] NULL,
[riskMortgRepaid] [bit] NULL,
[riskInvestVehicle] [bit] NULL,
[riskCharge] [bit] NULL,
[riskOverhang] [bit] NULL,
[riskMaxYears] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMortgageRisk_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TMortgageRisk] ADD CONSTRAINT [PK_TMortgageRisk] PRIMARY KEY NONCLUSTERED  ([MortgageRiskId]) WITH (FILLFACTOR=80)
GO
