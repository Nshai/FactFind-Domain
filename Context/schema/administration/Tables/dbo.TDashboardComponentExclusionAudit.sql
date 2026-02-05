CREATE TABLE [dbo].[TDashboardComponentExclusionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[Dashboard] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Component] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL,
[DashboardComponentExclusionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TDashboardComponentExclusionAudit] ADD CONSTRAINT [PK_TDashboardComponentExclusionAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
