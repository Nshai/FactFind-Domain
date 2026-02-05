CREATE TABLE [dbo].[TPensionContributionStrategyAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[TenantId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[Period] [nvarchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[Percentage] [decimal] (5, 2) NULL,
[Details] [nvarchar] (250) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPensionContributionStrategyAudit_ConcurrencyId] DEFAULT ((1)),
[PensionContributionStrategyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPensionContributionStrategyAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPensionContributionStrategyAudit] ADD CONSTRAINT [PK_TPensionContributionStrategyAudit] PRIMARY KEY NONCLUSTERED ([AuditId]) WITH (FILLFACTOR=90)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TPensionContributionStrategyAudit_PensionContributionStrategyId_ConcurrencyId] ON [dbo].[TPensionContributionStrategyAudit] ([PensionContributionStrategyId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
CREATE NONCLUSTERED INDEX [IX_TPensionContributionStrategyAudit_StampDateTime_ProtectionId] ON [dbo].[TPensionContributionStrategyAudit] ([StampDateTime], [PensionContributionStrategyId]) WITH (FILLFACTOR=90)
GO
