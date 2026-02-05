CREATE TABLE [dbo].[TRefEmailStorageConfigAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[StorageConfigName] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[IsTenantOnly] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefEmailStorageConfigAudit_ConcurrencyId] DEFAULT ((1)),
[RefEmailStorageConfigId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRefEmailStorageConfigAudit] ADD CONSTRAINT [PK_TRefEmailStorageConfigAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
