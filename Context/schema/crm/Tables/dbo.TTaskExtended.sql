CREATE TABLE [dbo].[TTaskExtended]
(
[TaskExtendedId] [int] NOT NULL IDENTITY(1, 1),
[TaskId] [int] NOT NULL,
[MigrationRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
create index IX_TTaskExtended_MigrationRef_IndigoClientId on TTaskExtended(MigrationRef,IndigoClientId) 
go 
create index IX_TTaskExtended_TaskId on TTaskExtended (TaskId) with (online = on, sort_in_tempdb = on)
go