CREATE TABLE [dbo].[TDatabaseVersion]
(
[DatabaseVersionId] [int] NOT NULL IDENTITY(1, 1),
[DatabaseVersion] [numeric] (8, 4) NULL,
[VersionDate] [datetime] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDatabaseVersion_CocurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TDatabaseVersion] ADD CONSTRAINT [PK_DatabaseVersionId] PRIMARY KEY NONCLUSTERED  ([DatabaseVersionId]) WITH (FILLFACTOR=80)
GO
