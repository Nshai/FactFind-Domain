CREATE TABLE [dbo].[TFeeModelToRoleAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FeeModelId] [int] NOT NULL,
[RoleId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[FeeModelToRoleId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NOT NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[TFeeModelToRoleAudit] ADD CONSTRAINT [PK_TFeeModelToRoleAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
