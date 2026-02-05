CREATE TABLE [dbo].[TInvestmentRiskProfileCorporate]
(
[InvestmentRiskProfileCorporateId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
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
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TInvestmentRiskProfileCorporate__ConcurrencyId] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TInvestmentRiskProfileCorporate_CRMContactId] ON [dbo].[TInvestmentRiskProfileCorporate] ([CRMContactId])
GO
