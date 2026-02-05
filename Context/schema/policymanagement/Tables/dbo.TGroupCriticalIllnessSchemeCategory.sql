CREATE TABLE [dbo].[TGroupCriticalIllnessSchemeCategory]
(
[GroupCriticalIllnessSchemeCategoryId] [int] NOT NULL IDENTITY(1, 1),
[GroupSchemeCategoryId] [int] NOT NULL,
[RefBenefitBasisId] [int] NULL,
[RefCoverToId] [int] NULL,
[UnitRate] [decimal] (18, 4) NULL,
[RefIllnessConditionTypeId] [int] NULL,
[CriticalIllnessCoverAmount] [money] NULL,
[RefTotalPermanentDisabilityTypeId] [int] NULL,
[SurvivalPeriod] [int] NULL,
[ChildrensCoverAmount] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[TenantId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TGroupCriticalIllnessSchemeCategory] ADD CONSTRAINT [PK_TGroupCriticalIllnessSchemeCategory] PRIMARY KEY CLUSTERED  ([GroupCriticalIllnessSchemeCategoryId])
GO
