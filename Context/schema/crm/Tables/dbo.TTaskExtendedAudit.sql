CREATE TABLE [dbo].[TTaskExtendedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[TaskId] [int] NOT NULL,
[MigrationRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[taskExtendedId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TTaskExtendedAudit] ADD CONSTRAINT [PK_TTaskExtendedAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
