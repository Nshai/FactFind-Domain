CREATE TABLE [dbo].[TTenantRuleConfigurationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[TenantRuleConfigurationId] [int] NOT NULL,
[RefRuleConfigurationId] [int] NOT NULL,
[IsConfigured] [bit] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TTenantRuleConfigurationAudit] ADD CONSTRAINT [PK_TTenantRuleConfigurationAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
