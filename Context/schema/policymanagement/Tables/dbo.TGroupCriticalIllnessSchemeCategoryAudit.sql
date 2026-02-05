CREATE TABLE [dbo].[TGroupCriticalIllnessSchemeCategoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[GroupCriticalIllnessSchemeCategoryId] [int] NOT NULL,
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
[TenantId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TGroupCriticalIllnessSchemeCategoryAudit] ADD CONSTRAINT [PK_TGroupCriticalIllnessSchemeCategoryAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
