CREATE TABLE [dbo].[TTenantRuleConfiguration]
(
[TenantRuleConfigurationId] [int] NOT NULL IDENTITY(1, 1),
[RefRuleConfigurationId] [int] NOT NULL,
[IsConfigured] [bit] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TTenantRuleConfiguration_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TTenantRuleConfiguration] ADD CONSTRAINT [PK_TTenantRuleConfiguration] PRIMARY KEY CLUSTERED  ([TenantRuleConfigurationId])
GO
ALTER TABLE [dbo].[TTenantRuleConfiguration] ADD CONSTRAINT [FK_TTenantRuleConfiguration_TRefRuleConfiguration] FOREIGN KEY ([RefRuleConfigurationId]) REFERENCES [dbo].[TRefRuleConfiguration] ([RefRuleConfigurationId])
GO
CREATE NONCLUSTERED INDEX IX_TTenantRuleConfiguration_IsConfigured_TenantId ON [dbo].[TTenantRuleConfiguration] ([IsConfigured],[TenantId]) 
GO