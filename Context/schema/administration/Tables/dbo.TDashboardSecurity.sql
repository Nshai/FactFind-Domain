CREATE TABLE [dbo].[TDashboardSecurity]
(
[DashboardSecurityId] [int] NOT NULL IDENTITY(1, 1),
[DashboardComponentId] [int] NOT NULL,
[RoleId] [int] NOT NULL,
[isAllowed] [bit] NOT NULL CONSTRAINT [DF_TDashboardSecurity_isAllowed] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDashboardSecurity_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TDashboardSecurity] ADD CONSTRAINT [PK_TDashboardSecurity] PRIMARY KEY NONCLUSTERED  ([DashboardSecurityId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TDashboardSecurity] ADD CONSTRAINT [FK_TDashboardSecurity_DashboardComponentId_TDashboardComponent] FOREIGN KEY ([DashboardComponentId]) REFERENCES [dbo].[TDashboardComponent] ([DashboardComponentId])
GO
