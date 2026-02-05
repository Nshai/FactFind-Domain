CREATE TABLE [dbo].[TDiaryPermission]
(
[DiaryPermissionId] [int] NOT NULL IDENTITY(1, 1),
[OwnerUserId] [int] NOT NULL,
[PermittedUserId] [int] NOT NULL,
[IsWriteAccess] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TDiaryPermission] ADD CONSTRAINT [PK_TDiaryPermission] PRIMARY KEY CLUSTERED  ([DiaryPermissionId])
GO
