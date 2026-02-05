CREATE TABLE [dbo].[TDashboardComponent]
(
[DashboardComponentId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDashboardComponent_ConcurrencyId] DEFAULT ((1)),
[TenantId] [int] NULL
)
GO
ALTER TABLE [dbo].[TDashboardComponent] ADD CONSTRAINT [PK_TDashboardComponent] PRIMARY KEY NONCLUSTERED  ([DashboardComponentId]) WITH (FILLFACTOR=80)
GO
