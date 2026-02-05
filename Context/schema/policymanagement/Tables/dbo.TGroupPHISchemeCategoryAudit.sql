CREATE TABLE [dbo].[TGroupPHISchemeCategoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[GroupPHISchemeCategoryId] [int] NOT NULL,
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
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TGroupPHISchemeCategoryAudit] ADD CONSTRAINT [PK_TGroupPHISchemeCategoryAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
