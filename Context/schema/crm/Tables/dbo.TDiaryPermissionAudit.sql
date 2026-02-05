CREATE TABLE [dbo].[TDiaryPermissionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[OwnerUserId] [int] NOT NULL,
[PermittedUserId] [int] NOT NULL,
[IsWriteAccess] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[DiaryPermissionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TDiaryPermissionAudit] ADD CONSTRAINT [PK_TDiaryPermissionAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
