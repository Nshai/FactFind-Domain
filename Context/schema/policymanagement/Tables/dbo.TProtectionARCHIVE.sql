CREATE TABLE [dbo].[TProtectionARCHIVE]
(
[ProtectionId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[RefPaymentOnId] [int] NULL,
[SumInsured] [money] NULL,
[NominatedBeneficiaries] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[MonthlyBenefit] [money] NULL,
[RefBenefitPeriodId] [int] NULL,
[RefWaitingPeriodId] [int] NULL,
[IsIndexed] [bit] NOT NULL,
[Loading] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RefCoverTypeId] [int] NULL,
[CoverNotes] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RenewalDate] [datetime] NULL,
[Exclusions] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
