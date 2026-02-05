CREATE TABLE [dbo].[TDashboardGroupAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Type] [tinyint] NOT NULL,
[OwnerType] [varchar] (max) COLLATE Latin1_General_CI_AS NOT NULL,
[TenantId] [int] NOT NULL,
[UserId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDashboardGroupAudit_ConcurrencyId] DEFAULT ((1)),
[DashboardGroupId] [uniqueidentifier] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TDashboardGroupAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TDashboardGroupAudit] ADD CONSTRAINT [PK_TDashboardGroupAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
