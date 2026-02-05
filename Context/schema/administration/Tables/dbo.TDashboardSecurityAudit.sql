CREATE TABLE [dbo].[TDashboardSecurityAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[DashboardComponentId] [int] NOT NULL,
[RoleId] [int] NOT NULL,
[isAllowed] [bit] NOT NULL CONSTRAINT [DF_TDashboardSecurityAudit_isAllowed] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDashboardSecurityAudit_ConcurrencyId] DEFAULT ((1)),
[DashboardSecurityId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TDashboardSecurityAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TDashboardSecurityAudit] ADD CONSTRAINT [PK_TDashboardSecurityAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TDashboardSecurityAudit_DashboardSecurityId_ConcurrencyId] ON [dbo].[TDashboardSecurityAudit] ([DashboardSecurityId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
