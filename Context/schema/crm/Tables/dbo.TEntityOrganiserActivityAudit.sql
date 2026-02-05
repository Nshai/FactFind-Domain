CREATE TABLE [dbo].[TEntityOrganiserActivityAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ActivityEntityTypeId] [int] NOT NULL,
[EntityId] [int] NOT NULL,
[OrganiserActivityId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[EntityOrganiserActivityId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEntityOrganiserActivityAudit] ADD CONSTRAINT [PK_TEntityOrganiserActivityAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
