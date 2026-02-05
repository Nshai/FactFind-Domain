CREATE TABLE [dbo].[TTenantDocumentStoreConfig]
(
[StorageConfigId] [int] IDENTITY(1,1) NOT NULL,
[TenantDocumentStoreConfigId] [uniqueidentifier] NULL,
[Name] [nvarchar](50) NULL,
[DocStoreType] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[Default] [bit] NOT NULL CONSTRAINT [DF_TTenantDocumentStoreConfig_Default] DEFAULT(0),
[ReadOnly] [bit] NOT NULL CONSTRAINT [DF_TTenantDocumentStoreConfig_ReadOnly] DEFAULT(0),
[BucketName] [nvarchar] (2000) COLLATE Latin1_General_CI_AS NULL,
[SecretKey] [nvarchar] (2000) COLLATE Latin1_General_CI_AS NULL,
[AccessKey] [nvarchar] (2000) COLLATE Latin1_General_CI_AS NULL,
[Region] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[EncryptionProfileId] [uniqueidentifier] NULL CONSTRAINT [DF_TTenantDocumentStoreConfig_EncryptionProfileId]  DEFAULT ('44e68e4e-c16b-44db-9c94-17a550780edc'),
[EncryptionAlgorithm] [tinyint] NULL,
[CreationDate] [datetime] NULL,
[CreatedBy] [int] NULL,
[CreatedByOidcClientId] [nvarchar](100) NULL
)
GO
ALTER TABLE [dbo].[TTenantDocumentStoreConfig] ADD CONSTRAINT [PK_TTenantDocumentStoreConfig] PRIMARY KEY CLUSTERED  ([StorageConfigId])
GO
ALTER TABLE [dbo].[TTenantDocumentStoreConfig] ADD CONSTRAINT [FK_TTenantDocumentStoreConfig_TIndigoClient] FOREIGN KEY ([TenantId]) REFERENCES [dbo].[TIndigoClient] ([IndigoClientId])
GO
CREATE INDEX IX_TTenantDocumentStoreConfig_TenantId_default on TTenantDocumentStoreConfig (TenantId, [default])
GO