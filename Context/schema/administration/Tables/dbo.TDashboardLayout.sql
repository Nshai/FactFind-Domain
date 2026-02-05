CREATE TABLE [dbo].[TDashboardLayout]
(
[DashboardId] [uniqueidentifier] NOT NULL,
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Layout] [varchar] (max) COLLATE Latin1_General_CI_AS NOT NULL,
[TenantId] [int] NOT NULL,
[IsPublic] [bit] NOT NULL CONSTRAINT [DF_TDashboardLayout_IsPublic] DEFAULT ((0)),
[OwnerId] [int] NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TDashboardLayout] ADD CONSTRAINT [PK_TDashboardLayout] PRIMARY KEY CLUSTERED  ([DashboardId])
GO
