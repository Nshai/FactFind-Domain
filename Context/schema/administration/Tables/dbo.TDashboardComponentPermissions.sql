CREATE TABLE [dbo].[TDashboardComponentPermissions]
(
[DashboardComponentPermissionsId] [int] NOT NULL IDENTITY(1, 1),
[DashboardComponentId] [int] NOT NULL,
[RoleId] [int] NOT NULL,
[isAllowed] [bit] NOT NULL CONSTRAINT [DF_TDashboardComponentPermissions_isAllowed] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDashboardComponentPermissions_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TDashboardComponentPermissions] ADD CONSTRAINT [PK_TDashboardComponentPermissions] PRIMARY KEY NONCLUSTERED  ([DashboardComponentPermissionsId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TDashboardComponentPermissions] ADD CONSTRAINT [FK_TDashboardComponentPermissions_DashboardComponentId_TDashboardComponent] FOREIGN KEY ([DashboardComponentId]) REFERENCES [dbo].[TDashboardComponent] ([DashboardComponentId])
GO
CREATE NONCLUSTERED INDEX IX_TDashboardComponentPermissions_RoleId ON [dbo].[TDashboardComponentPermissions] ([RoleId])
GO
CREATE NONCLUSTERED INDEX IX_TDashboardComponentPermissions_DashboardComponentId ON [dbo].[TDashboardComponentPermissions] ([DashboardComponentId]) INCLUDE ([DashboardComponentPermissionsId],[RoleId],[isAllowed],[ConcurrencyId])
GO
CREATE NONCLUSTERED INDEX IX_TDashboardComponentPermissions_RoleId_DashboardComponentId ON [dbo].[TDashboardComponentPermissions] ([RoleId],[DashboardComponentId]) include (isallowed)
GO
