CREATE TABLE [dbo].[TGroupLifeSchemeCategory]
(
[GroupLifeSchemeCategoryId] [int] NOT NULL IDENTITY(1, 1),
[GroupSchemeCategoryId] [int] NOT NULL,
[RefRegisteredId] [int] NULL,
[RefBenefitBasisId] [int] NULL,
[RefCoverToId] [int] NULL,
[IsCopyOfTrustHeld] [bit] NOT NULL CONSTRAINT [DF_TGroupLifeSchemeCategory_IsCopyOfTrustHeld] DEFAULT ((0)),
[IsEarningsCapApply] [bit] NOT NULL,
[SingleEventLimit] [money] NULL,
[UnitRate] [decimal] (18, 4) NULL,
[IsSchemeLinkedToDependent] [bit] NOT NULL,
[IsSchemeLinkedToGroup] [bit] NOT NULL,
[IsPrincipalEmployer] [bit] NOT NULL CONSTRAINT [DF_TGroupLifeSchemeCategory_IsPrincipalEmployer] DEFAULT ((0)),
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TGroupLifeSchemeCategory_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TGroupLifeSchemeCategory] ADD CONSTRAINT [PK_TGroupLifeSchemeCategory] PRIMARY KEY CLUSTERED  ([GroupLifeSchemeCategoryId])
GO
