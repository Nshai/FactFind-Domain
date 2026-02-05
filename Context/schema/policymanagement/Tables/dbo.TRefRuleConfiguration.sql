CREATE TABLE [dbo].[TRefRuleConfiguration]
(
[RefRuleConfigurationId] [int] NOT NULL IDENTITY(1, 1),
[RuleName] [nvarchar] (800) COLLATE Latin1_General_CI_AS NOT NULL,
[RefRuleCategoryId] [int] NULL,
[DefaultConfiguration] [bit] NOT NULL CONSTRAINT [DF_TRefRuleConfiguration_DefaultConfiguration] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TRefRuleConfiguration] ADD CONSTRAINT [PK_TRefRuleConfiguration] PRIMARY KEY CLUSTERED  ([RefRuleConfigurationId])
GO
ALTER TABLE [dbo].[TRefRuleConfiguration] ADD CONSTRAINT [FK_TRefRuleConfiguration_TRefRuleCategory] FOREIGN KEY ([RefRuleCategoryId]) REFERENCES [dbo].[TRefRuleCategory] ([RefRuleCategoryId])
GO
