CREATE TABLE [dbo].[TTenantGroupRuleConfigurationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[TenantGroupRuleConfigurationId] [int] NOT NULL,
[IsGroupTasksEnabled] [bit] NOT NULL,
[IsGroupChargingEnabled] [bit] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
