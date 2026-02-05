CREATE TABLE [dbo].[TTransitionRule]
(
[TransitionRuleId] [int] NOT NULL IDENTITY(1, 1),
[RuleSPName] [varchar] (128)  NOT NULL,
[LifeCycleTransitionId] [int] NOT NULL,
[Alias] [varchar] (1000)  NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TTransitionRule_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TTransitionRule] ADD CONSTRAINT [PK_TTransitionRule] PRIMARY KEY NONCLUSTERED  ([TransitionRuleId])
GO
CREATE NONCLUSTERED INDEX [IDX_TTransitionRule_LifeCycleTransitionId] ON [dbo].[TTransitionRule] ([LifeCycleTransitionId])
GO
ALTER TABLE [dbo].[TTransitionRule] WITH CHECK ADD CONSTRAINT [FK_TTransitionRule_TLifeCycleTransition] FOREIGN KEY ([LifeCycleTransitionId]) REFERENCES [dbo].[TLifeCycleTransition] ([LifeCycleTransitionId])
GO
