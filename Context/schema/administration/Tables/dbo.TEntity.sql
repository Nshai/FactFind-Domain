CREATE TABLE [dbo].[TEntity]
(
[EntityId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Identifier] [varchar] (128) COLLATE Latin1_General_CI_AS NOT NULL,
[Descriptor] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Db] [varchar] (128) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEntity_ConcurrencyId] DEFAULT ((1)),
)
GO
ALTER TABLE [dbo].[TEntity] ADD CONSTRAINT [PK_TEntity] PRIMARY KEY NONCLUSTERED  ([EntityId]) WITH (FILLFACTOR=80)
GO
