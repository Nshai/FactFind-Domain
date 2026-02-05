CREATE TABLE [dbo].[TDashboardComponentAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDashboardComponentAudit_ConcurrencyId] DEFAULT ((1)),
[DashboardComponentId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TDashboardComponentAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[TenantId] [int] NULL
)
GO
ALTER TABLE [dbo].[TDashboardComponentAudit] ADD CONSTRAINT [PK_TDashboardComponentAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TDashboardComponentAudit_DashboardComponentId_ConcurrencyId] ON [dbo].[TDashboardComponentAudit] ([DashboardComponentId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
