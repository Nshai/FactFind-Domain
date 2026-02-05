CREATE TABLE [dbo].[TTenantEmailConfig]
(
[TenantEmailConfigId] [int] NOT NULL IDENTITY(1, 1),
[RefEmailDuplicateConfigId] [int] NOT NULL,
[RefEmailStorageConfigId] [int] NOT NULL,
[RefEmailAttachmentConfigId] [int] NOT NULL,
[RefSaveEmailConfigId] [tinyint] NOT NULL DEFAULT ((1)),
[TenantId] [int] NOT NULL,
[IsAuthenticateSPF] [bit] NOT NULL CONSTRAINT [DF_TTenantEmailConfig_IsAuthenticateSPF] DEFAULT ((0)),
[IsAuthenticateSenderId] [bit] NOT NULL CONSTRAINT [DF_TTenantEmailConfig_IsAuthenticateSenderId] DEFAULT ((0)),
[IsAuthenticateDomainKey] [bit] NOT NULL CONSTRAINT [DF_TTenantEmailConfig_IsAuthenticateDomainKey] DEFAULT ((0)),
[MaximumEmailSize] [int] NOT NULL CONSTRAINT [DF_TTenantEmailConfig_MaxEmailSize] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TTenantEmailConfig_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TTenantEmailConfig] ADD CONSTRAINT [PK_TTenantEmailConfig] PRIMARY KEY CLUSTERED  ([TenantEmailConfigId])
GO
ALTER TABLE [dbo].[TTenantEmailConfig] ADD CONSTRAINT [FK_TTenantAttachmentConfig_TEmailStorageConfig] FOREIGN KEY ([RefEmailAttachmentConfigId]) REFERENCES [dbo].[TRefEmailStorageConfig] ([RefEmailStorageConfigId])
GO
ALTER TABLE [dbo].[TTenantEmailConfig] ADD CONSTRAINT [FK_TTenantEmailConfig_TRefEmailDuplicateConfig] FOREIGN KEY ([RefEmailDuplicateConfigId]) REFERENCES [dbo].[TRefEmailDuplicateConfig] ([RefEmailDuplicateConfigId])
GO
ALTER TABLE [dbo].[TTenantEmailConfig] ADD CONSTRAINT [FK_TTenantStorageConfig_TEmailStorageConfig] FOREIGN KEY ([RefEmailStorageConfigId]) REFERENCES [dbo].[TRefEmailStorageConfig] ([RefEmailStorageConfigId])
GO
ALTER TABLE [dbo].[TTenantEmailConfig] ADD CONSTRAINT [FK_TTenantEmailConfig_TTenant] FOREIGN KEY ([TenantId]) REFERENCES [dbo].[TIndigoClient] ([IndigoClientId])
GO
ALTER TABLE [dbo].[TTenantEmailConfig] ADD CONSTRAINT [FK_TTenantEmailConfig_TRefSaveEmailConfig] FOREIGN KEY ([RefSaveEmailConfigId]) REFERENCES [dbo].[TRefSaveEmailConfig] ([RefSaveEmailConfigId])
GO
