CREATE TABLE [dbo].[TDiscountToRoleAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[DiscountId] [int] NOT NULL,
[RoleId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[DiscountToRoleId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TDiscountToRoleAudit] ADD CONSTRAINT [PK_TDiscountToRoleAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
