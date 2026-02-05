CREATE TABLE [dbo].[TATRDataMigration](
	[DataMigrationId] [int] IDENTITY(1,1) NOT NULL,
	[IndigoClientId] [int] NOT NULL,
	[Stage] [varchar](20) NULL,
	[MigrationDate] [datetime] NULL,
	[MigrationScriptGuid] UniqueIdentifier NULL,
	[MigrationStatus] [varchar](20) NULL,
	[PostMigrationScriptGuid] UniqueIdentifier NULL,
	[PostMigrationStatus] [varchar](20) NULL,
	[RollBackMigrationScriptGuid] UniqueIdentifier NULL,
	[RollBackMigrationStatus] [varchar](20) NULL,
	[Message] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
