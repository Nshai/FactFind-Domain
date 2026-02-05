CREATE TABLE [dbo].[TLeadStatusToRole]
(
[LeadStatusToRoleId] [int] NOT NULL IDENTITY(1, 1),
[LeadStatusId] [int] NOT NULL,
[RoleId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLeadStatusToRole_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TLeadStatusToRole] ADD CONSTRAINT [PK_TLeadStatusToRole] PRIMARY KEY CLUSTERED  ([LeadStatusToRoleId])
GO
