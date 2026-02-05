CREATE TABLE [dbo].[TNoteAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[EntityType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[EntityId] [int] NULL,
[Notes] [text] COLLATE Latin1_General_CI_AS NULL,
[LatestNote] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TNoteAudit_ConcurrencyId] DEFAULT ((1)),
[NoteId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TNoteAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[MigrationRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PlanMigrationRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TNoteAudit] ADD CONSTRAINT [PK_TNoteAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TNoteAudit_EntityId_EntityType] ON [dbo].[TNoteAudit] ([EntityId], [EntityType])
GO
