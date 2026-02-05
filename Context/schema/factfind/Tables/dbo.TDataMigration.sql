CREATE TABLE [dbo].[TDataMigration]
(
[IndigoClientId] [int] NOT NULL,
[Identifier] [varchar] (64) COLLATE Latin1_General_CI_AS NOT NULL,
[doMigrate] [bit] NOT NULL CONSTRAINT [DF__TDataMigr__doMig__08B618C0] DEFAULT ((0)),
[isMigrated] [bit] NOT NULL CONSTRAINT [DF__TDataMigr__isMig__09AA3CF9] DEFAULT ((0)),
[MigrationDate] [datetime] NULL
)
GO
ALTER TABLE [dbo].[TDataMigration] ADD CONSTRAINT [PK__TDataMigration__07C1F487] PRIMARY KEY CLUSTERED  ([IndigoClientId]) WITH (FILLFACTOR=80)
GO
