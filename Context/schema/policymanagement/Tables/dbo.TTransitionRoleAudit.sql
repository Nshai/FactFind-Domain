CREATE TABLE [dbo].[TTransitionRoleAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RoleId] [int] NOT NULL,
[LifeCycleTransitionId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[TransitionRoleId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TTransitionRoleAudit] ADD CONSTRAINT [PK_TTransitionRoleAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
