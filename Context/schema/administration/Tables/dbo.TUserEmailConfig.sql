CREATE TABLE [dbo].[TUserEmailConfig]
(
[UserEmailConfigId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefEmailMatchingConfigId] [int] NOT NULL,
[RefEmailStorageConfigId] [int] NOT NULL,
[RefEmailAttachmentConfigId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[IsActive] [bit] NOT NULL CONSTRAINT [DF_TUserEmailConfig_IsActive] DEFAULT ((0)),
[Guid] [uniqueidentifier] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TUserEmailConfig_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TUserEmailConfig] ADD CONSTRAINT [PK_TUserEmailConfig] PRIMARY KEY CLUSTERED  ([UserEmailConfigId])
GO
ALTER TABLE [dbo].[TUserEmailConfig] ADD CONSTRAINT [FK_TUserEmailConfig_TAttachmentConfig] FOREIGN KEY ([RefEmailAttachmentConfigId]) REFERENCES [dbo].[TRefEmailStorageConfig] ([RefEmailStorageConfigId])
GO
ALTER TABLE [dbo].[TUserEmailConfig] ADD CONSTRAINT [FK_RefEmailMatchingConfig] FOREIGN KEY ([RefEmailMatchingConfigId]) REFERENCES [dbo].[TRefEmailMatchingConfig] ([RefEmailMatchingConfigId])
GO
ALTER TABLE [dbo].[TUserEmailConfig] ADD CONSTRAINT [FK_TRefEmailStorageConfig] FOREIGN KEY ([RefEmailStorageConfigId]) REFERENCES [dbo].[TRefEmailStorageConfig] ([RefEmailStorageConfigId])
GO
ALTER TABLE [dbo].[TUserEmailConfig] ADD CONSTRAINT [FK_TUser] FOREIGN KEY ([UserId]) REFERENCES [dbo].[TUser] ([UserId])
GO
