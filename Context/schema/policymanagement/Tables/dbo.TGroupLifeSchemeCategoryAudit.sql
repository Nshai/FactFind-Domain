CREATE TABLE [dbo].[TGroupLifeSchemeCategoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[GroupLifeSchemeCategoryId] [int] NULL,
[GroupSchemeCategoryId] [int] NULL,
[RefRegisteredId] [int] NULL,
[RefBenefitBasisId] [int] NULL,
[RefCoverToId] [int] NULL,
[IsCopyOfTrustHeld] [bit] NULL,
[IsEarningsCapApply] [bit] NULL,
[SingleEventLimit] [money] NULL,
[UnitRate] [decimal] (18, 4) NULL,
[IsSchemeLinkedToDependent] [bit] NULL,
[IsSchemeLinkedToGroup] [bit] NULL,
[IsPrincipalEmployer] [bit] NULL,
[ConcurrencyId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TGroupLifeSchemeCategoryAudit] ADD CONSTRAINT [PK_TGroupLifeSchemeCategoryAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
