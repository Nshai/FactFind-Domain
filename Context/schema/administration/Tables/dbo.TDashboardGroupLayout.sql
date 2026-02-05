CREATE TABLE [dbo].[TDashboardGroupLayout]
(
[DashboardGroupId] [uniqueidentifier] NOT NULL,
[DashboardId] [uniqueidentifier] NOT NULL,
[DisplayOrder] [tinyint] NOT NULL
)
GO
CREATE NONCLUSTERED INDEX IX_TDashboardGroupLayout_DashboardGroupId ON [dbo].[TDashboardGroupLayout] ([DashboardGroupId]) INCLUDE ([DashboardId],[DisplayOrder])
GO