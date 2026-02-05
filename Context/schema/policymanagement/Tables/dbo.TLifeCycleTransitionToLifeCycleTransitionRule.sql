CREATE TABLE [dbo].[TLifeCycleTransitionToLifeCycleTransitionRule]
(
[LifeCycleTransitionToLifeCycleTransitionRuleId] [int] NOT NULL IDENTITY(1, 1),
[LifeCycleTransitionId] [int] NOT NULL,
[LifeCycleTransitionRuleId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TTransitionRuleToLifeCycleTransition_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TLifeCycleTransitionToLifeCycleTransitionRule] ADD CONSTRAINT [PK_TTransitionRuleToLifeCycleTransition] PRIMARY KEY CLUSTERED  ([LifeCycleTransitionToLifeCycleTransitionRuleId])
GO
CREATE NONCLUSTERED INDEX IX_TLifeCycleTransitionToLifeCycleTransitionRule_LifeCycleTransitionId ON [dbo].[TLifeCycleTransitionToLifeCycleTransitionRule] ([LifeCycleTransitionId])
GO