CREATE TABLE [dbo].[TOpportunityLinkPlanSetupAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[OpportunityLinkPlanSetupId] [int] NOT NULL,
[AllowLinkToRelatedClients] [bit] NOT NULL,
[HideMigratedPlans] [bit] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TOpportunityLinkPlanSetupAudit_ConcurrencyId] DEFAULT ((1)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TOpportunityLinkPlanSetupAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TOpportunityLinkPlanSetupAudit] ADD CONSTRAINT [PK_TOpportunityLinkPlanSetupAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
