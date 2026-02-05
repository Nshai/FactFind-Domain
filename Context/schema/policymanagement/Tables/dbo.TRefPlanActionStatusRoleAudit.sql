CREATE TABLE [dbo].[TRefPlanActionStatusRoleAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[LifeCycleStepId] [int] NOT NULL,
[RefPlanActionId] [int] NOT NULL,
[RoleId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPlanActionStatusRoleAudit_ConcurrencyId] DEFAULT ((1)),
[RefPlanActionStatusRoleId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRefPlanActionStatusRoleAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefPlanActionStatusRoleAudit] ADD CONSTRAINT [PK_TRefPlanActionStatusRoleAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRefPlanActionStatusRoleAudit_RefPlanActionStatusRoleId_ConcurrencyId] ON [dbo].[TRefPlanActionStatusRoleAudit] ([RefPlanActionStatusRoleId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
