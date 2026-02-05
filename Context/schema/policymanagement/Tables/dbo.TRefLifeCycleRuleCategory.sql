CREATE TABLE [dbo].[TRefLifecycleRuleCategory]
(
[RefLifecycleRuleCategoryId] [int] IDENTITY(1,1) NOT NULL,
[CategoryName] [varchar](255) NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefLifecycleRuleCategory_ConcurrencyId]  DEFAULT ((1)) 
)
GO
ALTER TABLE [dbo].[TRefLifecycleRuleCategory] ADD CONSTRAINT [PK_TRefLifecycleRuleCategory] PRIMARY KEY CLUSTERED  ([RefLifecycleRuleCategoryId]) WITH (FILLFACTOR=80)
GO


