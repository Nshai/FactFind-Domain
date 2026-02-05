CREATE TABLE [dbo].[TRiskProfileTemplateCombinedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RiskProfileTemplateId] [int] NOT NULL,
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[TenantId] [int] NOT NULL,
[TenantGuid] [uniqueidentifier] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRiskProfileTemplateCombinedAudit_ConcurrencyId] DEFAULT ((1)),
[Guid] [uniqueidentifier] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRiskProfileTemplateCombinedAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRiskProfileTemplateCombinedAudit] ADD CONSTRAINT [PK_TRiskProfileTemplateCombinedAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
