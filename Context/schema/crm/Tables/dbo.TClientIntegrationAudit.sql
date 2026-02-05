CREATE TABLE [dbo].[TClientIntegrationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ClientReference] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IntegrationTypeId] [int] NOT NULL,
[IntegrationDate] [datetime] NOT NULL,
[ClientIntegrationId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TClientIntegrationAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TClientIntegrationAudit] ADD CONSTRAINT [PK_TClientIntegrationAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
