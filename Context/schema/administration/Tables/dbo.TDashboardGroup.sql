CREATE TABLE [dbo].[TDashboardGroup]
(
[DashboardGroupId] [uniqueidentifier] NOT NULL,
[Type] [tinyint] NOT NULL,
[OwnerType] [tinyint] NOT NULL,
[TenantId] [int] NOT NULL,
[UserId] [int] NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TDashboardGroup] ADD CONSTRAINT [PK_TDashboardGroup] PRIMARY KEY CLUSTERED  ([DashboardGroupId])
GO
CREATE NONCLUSTERED INDEX IX_TDashboardGroup_Type_TenantId ON [dbo].[TDashboardGroup] ([Type],[TenantId])
GO