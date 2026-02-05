CREATE TABLE [dbo].[TUserEmailConfigAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefEmailMatchingConfigId] [int] NOT NULL,
[RefEmailStorageConfigId] [int] NOT NULL,
[RefEmailAttachmentConfigId] [int] NOT NULL,
[UserId] [int] NOT NULL,
[IsActive] [bit] NOT NULL,
[Guid] [uniqueidentifier] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TUserEmailConfigAudit_ConcurrencyId] DEFAULT ((1)),
[UserEmailConfigId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TUserEmailConfigAudit] ADD CONSTRAINT [PK_TUserEmailConfigAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
