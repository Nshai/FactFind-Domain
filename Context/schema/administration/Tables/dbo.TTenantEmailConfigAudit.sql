CREATE TABLE [dbo].[TTenantEmailConfigAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefEmailDuplicateConfigId] [int] NOT NULL,
[RefEmailStorageConfigId] [int] NOT NULL,
[RefEmailAttachmentConfigId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[IsAuthenticateSPF] [bit] NOT NULL CONSTRAINT [DF_TTenantEmailConfigAudit_IsAuthenticateSPF] DEFAULT ((0)),
[IsAuthenticateSenderId] [bit] NOT NULL CONSTRAINT [DF_TTenantEmailConfigAudit_IsAuthenticateSenderId] DEFAULT ((0)),
[IsAuthenticateDomainKey] [bit] NOT NULL CONSTRAINT [DF_TTenantEmailConfigAudit_IsAuthenticateDomainKey] DEFAULT ((0)),
[MaximumEmailSize] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TTenantEmailConfigAudit_ConcurrencyId] DEFAULT ((1)),
[TenantEmailConfigId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TTenantEmailConfigAudit] ADD CONSTRAINT [PK_TTenantEmailConfigAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
