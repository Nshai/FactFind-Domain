CREATE TABLE [dbo].[TDashboardComponentPermissionsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[DashboardComponentId] [int] NOT NULL,
[RoleId] [int] NOT NULL,
[isAllowed] [bit] NOT NULL CONSTRAINT [DF_TDashboardComponentPermissionsAudit_isAllowed] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDashboardComponentPermissionsAudit_ConcurrencyId] DEFAULT ((1)),
[DashboardComponentPermissionsId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TDashboardComponentPermissionsAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TDashboardComponentPermissionsAudit] ADD CONSTRAINT [PK_TDashboardComponentPermissionsAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TDashboardComponentPermissionsAudit_DashboardSecurityId_ConcurrencyId] ON [dbo].[TDashboardComponentPermissionsAudit] ([DashboardComponentPermissionsId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
