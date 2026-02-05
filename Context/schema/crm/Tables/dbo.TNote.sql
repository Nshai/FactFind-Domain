CREATE TABLE [dbo].[TNote]
(
[NoteId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[EntityType] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[EntityId] [int] NULL,
[Notes] [text] COLLATE Latin1_General_CI_AS NULL,
[LatestNote] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TNote_ConcurrencyId] DEFAULT ((1)),
MigrationRef varchar(255),
PlanMigrationRef varchar(255)
)
GO
ALTER TABLE [dbo].[TNote] ADD CONSTRAINT [PK_TNote] PRIMARY KEY CLUSTERED  ([NoteId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TNote_EntityType_EntityId] ON [dbo].[TNote] ([EntityType], [EntityId]) WITH (FILLFACTOR=80)
GO
create index IX_TNote_MigrationRef on TNote(MigrationRef) 
go
create index IX_TNote_PlanMigrationRef on Tnote(PlanMigrationRef) 
go 
