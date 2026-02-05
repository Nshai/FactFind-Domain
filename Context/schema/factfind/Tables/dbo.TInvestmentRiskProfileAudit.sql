CREATE TABLE [dbo].[TInvestmentRiskProfileAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
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
[CRMContactId] [int] NOT NULL,
[InvestmentRiskProfileId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TInvestme__Concu__71A7CADF] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TInvestmentRiskProfileAudit] ADD CONSTRAINT [PK_TInvestmentRiskProfileAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
