CREATE TABLE [dbo].[TLinearPilotBenefit]
(
[LinearPilotBenefitId] [int] NOT NULL IDENTITY(1, 1),
[LifeAssuredPartyId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[BenefitType] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[PaymentBasis] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[PaymentType] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[BenefitAmount] [money] NULL,
[BenefitFrequency] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[PremiumType] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[StartDate] [datetime] NULL,
[RenewalDate] [datetime] NULL,
[ExpiryDate] [datetime] NULL,
[OriginalTerm] [smallint] NULL,
[RemainingTerm] [smallint] NULL,
[BenefitPaymentTerm] [smallint] NULL,
[DateOfFirstRenewal] [datetime] NULL,
[IsRecurring] [bit] NULL,
[RenewalFrequency] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[BenefitVariation] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[BenefitIncreaseDecreaseRate] [decimal] (5, 2) NULL,
[IsTerminalIllnesCovered] [bit] NULL,
[LifeCoverOption] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[DeferredPeriod] [smallint] NULL,
[RetirementAge] [smallint] NULL,
[OccupationBasis] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[IsPrivateHospitalBenefit] [bit] NULL,
[TaxStatus] [varchar] (128) COLLATE Latin1_General_CI_AS NULL,
[IsFamilyIncomeBenefit] [bit] NULL,
[IsIntrust] [bit] NULL,
[InTrustWithWhom] [varchar] (256) COLLATE Latin1_General_CI_AS NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLinearPilotBenefit_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TLinearPilotBenefit] ADD CONSTRAINT [PK_TLinearPilotBenefit] PRIMARY KEY CLUSTERED  ([LinearPilotBenefitId])
GO
