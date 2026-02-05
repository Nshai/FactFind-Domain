CREATE TABLE [dbo].[TDashboardGroupLayoutAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[DashboardGroupId] [uniqueidentifier] NOT NULL,
[DashboardId] [uniqueidentifier] NOT NULL,
[DisplayOrder] [tinyint] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TDashboardGroupLayoutAudit] ADD CONSTRAINT [PK_TDashboardGroupLayoutAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
