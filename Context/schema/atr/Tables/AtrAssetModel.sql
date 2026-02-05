CREATE TABLE [dbo].[TAtrAssetModel](
	[AtrAssetModelId] [int] IDENTITY(1,1) NOT NULL,
	[AtrAssetModelJson] [nvarchar](max) NOT NULL,
	[CreatedAt] [datetime2] NOT NULL,
	[UpdatedAt] [datetime2] NOT NULL,
	[MigrationRef][nvarchar](max) NULL CONSTRAINT [DF_TAtrAssetModel_MigrationRef] DEFAULT (NULL),
 CONSTRAINT [PK_TAtrAssetModel] PRIMARY KEY CLUSTERED 
 (
	[AtrAssetModelId] ASC
 )
) 
GO

ALTER TABLE [dbo].[TAtrAssetModel] ADD  CONSTRAINT [DF_TAtrAssetModel_CreatedAt]  DEFAULT (GetUTCDate()) FOR [CreatedAt]
GO

ALTER TABLE [dbo].[TAtrAssetModel] ADD  CONSTRAINT [DF_TAtrAssetModel_UpdatedAt]  DEFAULT (GetUTCDate()) FOR [UpdatedAt]
GO

