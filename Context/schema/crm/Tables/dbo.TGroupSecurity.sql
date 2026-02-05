CREATE TABLE [dbo].[TGroupSecurity]
(
[GroupSecurityId] [int] NOT NULL IDENTITY(1, 1),
[GroupId] [int] NOT NULL,
[IsActivityCategoryPropagationAllowed] [bit] NOT NULL CONSTRAINT [DF_TGroupSecurity_IsActivityCategoryPropagationAllowed] DEFAULT ((0)),
[IsEventListPropagationAllowed] [bit] NOT NULL CONSTRAINT [DF_TGroupSecurity_IsEventListPropagationAllowed] DEFAULT ((0)),
[IsFeeModelPropagationAllowed] [bit] NOT NULL CONSTRAINT [DF_TGroupSecurity_IsFeeModelPropagationAllowed] DEFAULT ((0)),
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TGroupSecurity_ConcurrencyId] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TGroupSecurity_TenantId_GroupId] ON [dbo].[TGroupSecurity] ([TenantId], [GroupId])
GO
