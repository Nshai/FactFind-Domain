CREATE TABLE [dbo].[TBenefit]
(
[BenefitId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[BenefitAmount] [money] NULL,
[PremiumWaiverWoc] [bit] NULL,
[BenefitDeferredPeriod] [int] NULL,
[IsRated] [bit] NULL,
[BenefitOptions] [int] NULL,
[RefPeriodTypeId] [int] NULL,
[RefTotalPermanentDisabilityTypeId] [int] NULL,
[RefFrequencyId] [int] NULL,
[RefBenefitPeriodId] [int] NULL,
[RefQualificationPeriodId] [int] NULL,
[IndigoClientId] [int] NULL,
[SplitBenefitAmount] [decimal] (18, 6) NULL,
[SplitBenefitDeferredPeriod] [int] NULL,
[RefSplitFrequencyId] [int] NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TBenefit_ConcurrencyId] DEFAULT ((1)),
[PensionCommencementLumpSum] [money] NULL,
[IsSpousesBenefit] [bit] NULL,
[SpousesOrDependentsPercentage] [decimal] (5, 2) NULL,
[GuaranteedPeriod] [int] NULL,
[IsProportion] [bit] NULL,
[PCLSPaidById] [int] NULL,
[IsCapitalValueProtected] [bit] NULL,
[CapitalValueProtectedAmount] [money] NULL,
[GADMaximumIncomeLimit] [money] NULL,
[GADCalculationDate] [datetime] NULL,
[GuaranteedMinimumIncome] [money] NULL,
[LumpSumDeathBenefitAmount] [money] NULL,
[DeferredPeriodIntervalId] [int] NULL,
[SplitDeferredPeriodIntervalId] [int] NULL,
[IsOverlap] [bit] NULL,
[OtherBenefitPeriodText] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsProtectedPCLS] [bit] NULL,
[PlanMigrationRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PolicyBusinessId] [int] NULL,
[IsPre75] [bit] NULL
)
GO
ALTER TABLE [dbo].[TBenefit] ADD CONSTRAINT [PK_TBenefit] PRIMARY KEY CLUSTERED  ([BenefitId])
GO
CREATE NONCLUSTERED INDEX [IX_TBenefit_PlanMigrationRef] ON [dbo].[TBenefit] ([PlanMigrationRef])
GO
CREATE NONCLUSTERED INDEX IX_TBenefit_PolicyBusinessId ON [dbo].[TBenefit] ([PolicyBusinessId])
GO