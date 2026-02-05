CREATE TABLE [dbo].[TDashboardComponentExclusion]
(
[DashboardComponentExclusionId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[Dashboard] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Component] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
