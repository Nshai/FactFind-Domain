CREATE TABLE [dbo].[TInvestmentRiskProfile]
(
[InvestmentRiskProfileId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[MarketComfort] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[MarketOpps] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[MarketFall] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[BankComfort] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[MarketSleep] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[RiskRating] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[AgreedLumpFundsCurr] [money] NULL,
[WhenFundsAvailable] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[SourceFundsAvailable] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[InvestmentTerm] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[InvestmentObj] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[EmergencyIncomeCurr] [money] NULL,
[Involvement] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[EmergencyFundsCurr] [money] NULL,
[EthicalYN] [bit] NULL,
[InvestmentRiskRating] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TInvestme__Concu__1DF06171] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TInvestmentRiskProfile_CRMContactId] ON [dbo].[TInvestmentRiskProfile] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
