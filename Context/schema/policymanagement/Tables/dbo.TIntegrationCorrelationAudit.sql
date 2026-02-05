CREATE TABLE [dbo].[TIntegrationCorrelationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CorrelationId] [uniqueidentifier] NOT NULL,
[EntityId] [int] NOT NULL,
[EntityType] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[PortalId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[IntegrationCorrelationId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TIntegrationCorrelationAudit] ADD CONSTRAINT [PK_TIntegrationCorrelationAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
