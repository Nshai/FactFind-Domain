CREATE TABLE [dbo].[TInvestmentRiskProfileCorporateAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Owner] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[InvestmentRiseAndFall] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[OppToBuyCheaper] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[BusinessInvestmentsCouldFall] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[PreferSecurityOfBank] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[RapidRiseAndFall] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Term] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[IncomeLevel] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[SpecificAmount] [money] NULL,
[MakeOwnInvestmentDecisions] [bit] NULL,
[DoYouWantEmergencyFunds] [bit] NULL,
[EmergencyAmount] [money] NULL,
[Notes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[InvestmentRiskProfileCorporateId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TInvestmentRiskProfileCorporateAudit__ConcurrencyId] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TInvestmentRiskProfileCorporateAudit] ADD CONSTRAINT [PK_TInvestmentRiskProfileCorporateAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
