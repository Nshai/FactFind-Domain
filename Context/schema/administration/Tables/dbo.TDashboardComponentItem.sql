CREATE TABLE [dbo].[TDashboardComponentItem]
(
[DashboardComponentItemId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[DashboardComponentId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ItemName] [varchar] (512) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (1024) COLLATE Latin1_General_CI_AS NULL,
[Value] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDashboardComponentItem_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TDashboardComponentItem] ADD CONSTRAINT [PK_TDashboardComponentItem] PRIMARY KEY CLUSTERED  ([DashboardComponentItemId])
GO
ALTER TABLE [dbo].[TDashboardComponentItem] ADD CONSTRAINT [FK_TDashboardComponentItem_DashboardComponent_DashboardComponentId] FOREIGN KEY ([DashboardComponentId]) REFERENCES [dbo].[TDashboardComponent] ([DashboardComponentId])
GO
CREATE NONCLUSTERED INDEX IX_TDashboardComponentItem_TenantID_ItemName ON [dbo].[TDashboardComponentItem] ([TenantId],[ItemName])
GO