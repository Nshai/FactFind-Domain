CREATE TABLE [dbo].[TPolicyBusinessIntegrationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[Guid] [uniqueidentifier] NOT NULL,
[PolicyBusinessIntegrationId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyBusinessIntegrationAudit_ConcurrencyId] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPolicyBusinessIntegrationAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPolicyBusinessIntegrationAudit] ADD CONSTRAINT [PK_TPolicyBusinessIntegrationAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
