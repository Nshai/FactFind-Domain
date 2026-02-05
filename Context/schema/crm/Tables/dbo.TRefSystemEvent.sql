CREATE TABLE [dbo].[TRefSystemEvent]
(
[RefSystemEventId] [int] NOT NULL IDENTITY(0, 1) NOT FOR REPLICATION,
[Identifier] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefSystemEvent_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TRefSystemEvent] ADD CONSTRAINT [PK_TRefSystemEvent] PRIMARY KEY CLUSTERED  ([RefSystemEventId]) WITH (FILLFACTOR=80)
GO
