CREATE TABLE [dbo].[TGroupPersonalPensionSchemeCategoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[GroupSchemeCategoryId] [int] NULL,
[RefCoverToId] [int] NULL,
[AccrualRate] [int] NULL,
[RefSalaryExchangeforEmployerId] [int] NULL,
[EmployerPercentagetoPension] [decimal] (8, 2) NULL,
[RefSalaryExchangeforEmployeeId] [int] NULL,
[IsEarlyRetirementOption] [bit] NULL,
[IsLateRetirementOption] [bit] NULL,
[EarliestRetirementAge] [int] NULL,
[LatestRetirementAge] [int] NULL,
[IsSchemeLinkedtoGroupLife] [bit] NULL,
[MSRtoEmployerContribution] [int] NULL,
[RefMinimumServiceRequirementTypeId] [int] NULL,
[RefChangesTakeEffectId] [int] NULL,
[TenantId] [int] NULL,
[ConcurrencyId] [int] NULL,
[GroupPersonalPensionSchemeCategoryId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TGroupPersonalPensionSchemeCategoryAudit] ADD CONSTRAINT [PK_TGroupPersonalPensionSchemeCategoryAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
