CREATE TABLE [dbo].[TLifeCycleTransitionRule]
(
[LifeCycleTransitionRuleId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Code] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (500) COLLATE Latin1_General_CI_AS NOT NULL,
[SpName] [varchar] (150) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[RefLifecycleRuleCategoryId] [int] NULL
)
GO
ALTER TABLE [dbo].[TLifeCycleTransitionRule] ADD CONSTRAINT [PK_TLifeCycleTransitionRule] PRIMARY KEY CLUSTERED  ([LifeCycleTransitionRuleId])
GO
