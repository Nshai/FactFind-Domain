CREATE TABLE [dbo].[TIntegrationTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[IntegrationTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IsEnabled] [bit] NOT NULL,
[IntegrationTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TIntegrationTypeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TIntegrationTypeAudit] ADD CONSTRAINT [PK_TIntegrationTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
