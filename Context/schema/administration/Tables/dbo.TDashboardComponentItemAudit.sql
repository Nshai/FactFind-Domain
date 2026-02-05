CREATE TABLE [dbo].[TDashboardComponentItemAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[DashboardComponentId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ItemName] [varchar] (512) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (1024) COLLATE Latin1_General_CI_AS NULL,
[Value] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDashboardComponentItemAudit_ConcurrencyId] DEFAULT ((1)),
[DashboardComponentItemId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TDashboardComponentItemAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TDashboardComponentItemAudit] ADD CONSTRAINT [PK_TDashboardComponentItemAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
