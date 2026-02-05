CREATE TABLE [dbo].[TFeeModelToRole]
(
[FeeModelToRoleId] [int] NOT NULL IDENTITY(1, 1),
[FeeModelId] [int] NOT NULL,
[RoleId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFeeModelToRole_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFeeModelToRole] ADD CONSTRAINT [PK_TFeeModelToRole] PRIMARY KEY CLUSTERED  ([FeeModelToRoleId])
GO
CREATE NONCLUSTERED INDEX [IX_TFeeModelToRole_FeeModelId] ON [dbo].[TFeeModelToRole] ([FeeModelId])
GO
CREATE NONCLUSTERED INDEX [IX_TFeeModelToRole_TenantId] ON [dbo].[TFeeModelToRole] ([TenantId])
GO
ALTER TABLE [dbo].[TFeeModelToRole] ADD CONSTRAINT [FK_TFeeModelToRole_TFeeModelToRole] FOREIGN KEY ([FeeModelId]) REFERENCES [dbo].[TFeeModel] ([FeeModelId]) ON DELETE CASCADE
GO
CREATE NONCLUSTERED INDEX IX_TFeeModelToRole_RoleID ON [dbo].[TFeeModelToRole] ([RoleId])
GO