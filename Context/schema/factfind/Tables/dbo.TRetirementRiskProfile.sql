CREATE TABLE [dbo].[TRetirementRiskProfile]
(
[RetirementRiskProfileId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[MarketComfort] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[MarketOpps] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[MarketFall] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[BankComfort] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[MarketSleep] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[RetirementRiskRating] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TRetireme__Concu__0C90CB45] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TRetirementRiskProfile_CRMContactId] ON [dbo].[TRetirementRiskProfile] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
