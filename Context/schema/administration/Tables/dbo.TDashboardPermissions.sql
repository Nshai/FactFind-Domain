CREATE TABLE [dbo].[TDashboardPermissions]
(
[DashboardPermissionsId] [int] NOT NULL IDENTITY(1, 1),
[DashboardId] [uniqueidentifier] NOT NULL,
[RoleId] [int] NOT NULL,
[isAllowed] [bit] NOT NULL CONSTRAINT [DF_TDashboardPermissions_isAllowed] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TDashboardPermissions] ADD CONSTRAINT [PK_TDashboardPermissions] PRIMARY KEY CLUSTERED  ([DashboardPermissionsId])
GO
CREATE NONCLUSTERED INDEX IX_TDashboardPermissions_RoleId ON [dbo].[TDashboardPermissions] ([RoleId]) INCLUDE ([DashboardPermissionsId],[DashboardId],[isAllowed],[ConcurrencyId])
GO