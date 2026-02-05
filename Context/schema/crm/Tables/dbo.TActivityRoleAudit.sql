CREATE TABLE [dbo].[TActivityRoleAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[EventListTemplateActivityId] [int] NOT NULL,
[RoleId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[ActivityRoleId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TActivityRoleAudit] ADD CONSTRAINT [PK_TActivityRoleAudit] PRIMARY KEY CLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
