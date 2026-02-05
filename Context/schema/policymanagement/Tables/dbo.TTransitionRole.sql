CREATE TABLE [dbo].[TTransitionRole]
(
[TransitionRoleId] [int] NOT NULL IDENTITY(1, 1),
[RoleId] [int] NOT NULL,
[LifeCycleTransitionId] [int] NOT NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TTransitionRole_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TTransitionRole] ADD CONSTRAINT [PK_TTransitionRole] PRIMARY KEY NONCLUSTERED  ([TransitionRoleId])
GO
CREATE NONCLUSTERED INDEX [IDX_TTransitionRole_LifeCycleTransitionId] ON [dbo].[TTransitionRole] ([LifeCycleTransitionId])
GO
ALTER TABLE [dbo].[TTransitionRole] WITH CHECK ADD CONSTRAINT [FK_TTransitionRole_TLifeCycleTransition] FOREIGN KEY ([LifeCycleTransitionId]) REFERENCES [dbo].[TLifeCycleTransition] ([LifeCycleTransitionId])
GO
