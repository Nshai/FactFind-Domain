CREATE TABLE [dbo].[TDashboardLayoutAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[Layout] [varchar] (max) COLLATE Latin1_General_CI_AS NOT NULL,
[TenantId] [int] NOT NULL,
[IsPublic] [bit] NOT NULL CONSTRAINT [DF_TDashboardLayoutAudit_IsPublic] DEFAULT ((0)),
[OwnerId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDashboardLayoutAudit_ConcurrencyId] DEFAULT ((1)),
[DashboardId] [uniqueidentifier] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TDashboardLayoutAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TDashboardLayoutAudit] ADD CONSTRAINT [PK_TDashboardLayoutAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TDashboardLayoutAudit_DashboardId_ConcurrencyId] ON [dbo].[TDashboardLayoutAudit] ([DashboardId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
