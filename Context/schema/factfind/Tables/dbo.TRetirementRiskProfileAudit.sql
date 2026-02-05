CREATE TABLE [dbo].[TRetirementRiskProfileAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[MarketComfort] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[MarketOpps] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[MarketFall] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[BankComfort] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[MarketSleep] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[RetirementRiskRating] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[RetirementRiskProfileId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TRetireme__Concu__604834B3] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRetirementRiskProfileAudit] ADD CONSTRAINT [PK_TRetirementRiskProfileAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
