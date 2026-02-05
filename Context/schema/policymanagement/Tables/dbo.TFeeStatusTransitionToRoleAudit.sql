CREATE TABLE [dbo].[TFeeStatusTransitionToRoleAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FeeStatusTransitionId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[RoleId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[FeeStatusTransitionToRoleId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFeeStatusTransitionToRoleAudit] ADD CONSTRAINT [PK_TFeeStatusTransitionToRoleAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
