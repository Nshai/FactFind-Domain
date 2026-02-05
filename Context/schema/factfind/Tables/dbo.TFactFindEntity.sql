CREATE TABLE [dbo].[TFactFindEntity]
(
[FactFindEntityId] [int] NOT NULL IDENTITY(1, 1),
[EntityName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[XmlDefinition] [varchar] (8000) COLLATE Latin1_General_CI_AS NOT NULL,
[DataStore] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFactFindEntity_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFactFindEntity] ADD CONSTRAINT [PK_TFactFindEntity] PRIMARY KEY CLUSTERED  ([FactFindEntityId]) WITH (FILLFACTOR=80)
GO
