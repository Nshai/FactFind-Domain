CREATE TABLE [dbo].[TOpportunityPolicyBusinessAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[OpportunityId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[OpportunityPolicyBusinessId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TOpportunityPolicyBusinessAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TOpportunityPolicyBusinessAudit] ADD CONSTRAINT [PK_TOpportunityPolicyBusinessAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
