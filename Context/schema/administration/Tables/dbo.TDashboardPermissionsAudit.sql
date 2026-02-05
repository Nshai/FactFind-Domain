CREATE TABLE [dbo].[TDashboardPermissionsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[DashboardId] [uniqueidentifier] NOT NULL,
[RoleId] [int] NOT NULL,
[isAllowed] [bit] NOT NULL CONSTRAINT [DF_TDashboardPermissionsAudit_isAllowed] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDashboardPermissionsAudit_ConcurrencyId] DEFAULT ((1)),
[DashboardPermissionsId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TDashboardPermissionsAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TDashboardPermissionsAudit] ADD CONSTRAINT [PK_TDashboardPermissionsAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
