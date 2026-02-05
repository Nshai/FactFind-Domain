CREATE TABLE [dbo].[TTenantGroupRuleConfiguration]
(
[TenantGroupRuleConfigurationId] [int] NOT NULL IDENTITY(1, 1),
[IsGroupTasksEnabled] [bit] NOT NULL CONSTRAINT [DF_TTenantGroupRuleConfiguration_IsGroupTasksEnabled] DEFAULT ((0)),
[IsGroupChargingEnabled] [bit] NOT NULL CONSTRAINT [DF_TTenantGroupRuleConfiguration_IsGroupChargingEnabled] DEFAULT ((0)),
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TTenantGroupRuleConfiguration_ConcurrencyId] DEFAULT ((1))
)
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_TTenantGroupRuleConfiguration_TenantId] ON [dbo].[TTenantGroupRuleConfiguration] ([TenantId])
GO
