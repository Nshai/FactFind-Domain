CREATE TABLE [dbo].[TGroupPHISchemeCategory]
(
[GroupPHISchemeCategoryId] [int] NOT NULL IDENTITY(1, 1),
[GroupSchemeCategoryId] [int] NOT NULL,
[RefBenefitBasisId] [int] NULL,
[RefBenefitFrequencyId] [int] NULL,
[SplitCoverAmount] [money] NULL,
[RefSplitBenefitFrequencyId] [int] NULL,
[SplitDeferredPeriod] [int] NULL,
[RefSplitDeferredPeriodIntervalId] [int] NULL,
[RefDeductionId] [int] NULL,
[RefCoverToId] [int] NULL,
[UnitRate] [decimal] (18, 4) NULL,
[RefClaimEscalationTypeId] [int] NULL,
[RefTotalPermanentDisabilityTypeId] [int] NULL,
[RefContributionsCoveredId] [int] NULL,
[EmployerNICovered] [bit] NULL,
[HolidayPayCovered] [bit] NULL,
[DiscountforConcurrentPMI] [bit] NULL,
[EAPIncluded] [bit] NULL,
[ExtendedCoverAvailable] [bit] NULL,
[CoverlinkedGroupPension] [bit] NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TGroupPHISchemeCategory] ADD CONSTRAINT [PK_TGroupPHISchemeCategory] PRIMARY KEY CLUSTERED  ([GroupPHISchemeCategoryId])
GO
