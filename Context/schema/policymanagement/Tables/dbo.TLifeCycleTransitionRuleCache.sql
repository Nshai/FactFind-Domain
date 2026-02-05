CREATE TABLE [dbo].[TLifeCycleTransitionRuleCache]
(
[LifeCycleTransitionRuleCacheId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[LifecycleTransitionId] [int] NOT NULL,
[LifecycleTransitionRuleId] [int] NOT NULL,
[Timeout] [datetime] NOT NULL
)
GO
ALTER TABLE [dbo].[TLifeCycleTransitionRuleCache] ADD CONSTRAINT [PK_TLifecycleTranistionRuleCache] PRIMARY KEY CLUSTERED  ([LifeCycleTransitionRuleCacheId])
GO
CREATE NONCLUSTERED INDEX [IX_TLifeCycleTransitionRuleCache_PolicyBusinessId_LifecycleTransitionId] ON [dbo].[TLifeCycleTransitionRuleCache] ([PolicyBusinessId], [LifecycleTransitionId])
GO
