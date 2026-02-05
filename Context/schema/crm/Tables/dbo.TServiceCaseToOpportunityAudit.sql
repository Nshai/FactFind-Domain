CREATE TABLE [dbo].[TServiceCaseToOpportunityAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[OpportunityId] [int] NOT NULL,
[AdviceCaseId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TServiceCaseToOpportunityAudit_ConcurrencyId] DEFAULT ((1)),
[ServiceCaseToOpportunityId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TServiceCaseToOpportunityAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TServiceCaseToOpportunityAudit] ADD CONSTRAINT [PK_TServiceCaseToOpportunityAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
