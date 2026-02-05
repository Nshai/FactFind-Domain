CREATE TABLE [dbo].[TKey]
(
[KeyId] [int] NOT NULL IDENTITY(1, 1),
[RightMask] [int] NOT NULL CONSTRAINT [DF_TKey_RightMask] DEFAULT ((0)),
[SystemId] [int] NOT NULL,
[UserId] [int] NULL,
[RoleId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TKey_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TKey] ADD CONSTRAINT [PK_TKey] PRIMARY KEY NONCLUSTERED  ([KeyId])
GO
CREATE NONCLUSTERED INDEX [IDX_TKey_RoleId] ON [dbo].[TKey] ([RoleId])
GO
CREATE NONCLUSTERED INDEX [IDX_TKey_RoleId_KeyId_ConcurrencyId] ON [dbo].[TKey] ([RoleId], [KeyId], [ConcurrencyId])
GO
CREATE NONCLUSTERED INDEX [IDX_TKey_RoleId_SystemId] ON [dbo].[TKey] ([RoleId], [SystemId])
GO
CREATE NONCLUSTERED INDEX [IDX_TKey_SystemId] ON [dbo].[TKey] ([SystemId])
GO
CREATE CLUSTERED INDEX [IDX_TKey_User_Id_RoleId_SystemId_RightMask_KeyId] ON [dbo].[TKey] ([UserId], [RoleId], [SystemId], [RightMask], [KeyId])
GO
ALTER TABLE [dbo].[TKey] WITH CHECK ADD CONSTRAINT [FK_TKey_TRole] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[TRole] ([RoleId])
GO
ALTER TABLE [dbo].[TKey] ADD CONSTRAINT [FK_TKey_SystemId_SystemId] FOREIGN KEY ([SystemId]) REFERENCES [dbo].[TSystem] ([SystemId])
GO
ALTER TABLE [dbo].[TKey] WITH CHECK ADD CONSTRAINT [FK_TKey_UserId_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[TUser] ([UserId])
GO
