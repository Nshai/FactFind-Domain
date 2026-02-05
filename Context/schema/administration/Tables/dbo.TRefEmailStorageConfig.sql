CREATE TABLE [dbo].[TRefEmailStorageConfig]
(
[RefEmailStorageConfigId] [int] NOT NULL IDENTITY(1, 1),
[StorageConfigName] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[IsTenantOnly] [bit] NOT NULL CONSTRAINT [DF_TRefEmailStorageConfig_IsTenantOnly] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefEmailStorageConfig_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefEmailStorageConfig] ADD CONSTRAINT [PK_TRefEmailStorageConfig] PRIMARY KEY CLUSTERED  ([RefEmailStorageConfigId])
GO
