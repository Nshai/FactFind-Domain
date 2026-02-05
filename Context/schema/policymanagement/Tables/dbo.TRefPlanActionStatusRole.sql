CREATE TABLE [dbo].[TRefPlanActionStatusRole]
(
[RefPlanActionStatusRoleId] [int] NOT NULL IDENTITY(1, 1),
[LifeCycleStepId] [int] NOT NULL,
[RefPlanActionId] [int] NOT NULL,
[RoleId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPlanActionStatusRole_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefPlanActionStatusRole] ADD CONSTRAINT [PK_TRefPlanActionStatusRole] PRIMARY KEY NONCLUSTERED  ([RefPlanActionStatusRoleId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRefPlanActionStatusRole_LifeCycleStepId] ON [dbo].[TRefPlanActionStatusRole] ([LifeCycleStepId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TRefPlanActionStatusRole] ADD CONSTRAINT [FK_TRefPlanActionStatusRole_TLifeCycleStep] FOREIGN KEY ([LifeCycleStepId]) REFERENCES [dbo].[TLifeCycleStep] ([LifeCycleStepId])
GO
ALTER TABLE [dbo].[TRefPlanActionStatusRole] ADD CONSTRAINT [FK_TRefPlanActionStatusRole_RefPlanActionId_TRefPlanAction] FOREIGN KEY ([RefPlanActionId]) REFERENCES [dbo].[TRefPlanAction] ([RefPlanActionId])
GO
