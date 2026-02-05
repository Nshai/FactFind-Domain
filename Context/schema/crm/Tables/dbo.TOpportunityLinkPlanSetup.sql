CREATE TABLE [dbo].[TOpportunityLinkPlanSetup]
(
[OpportunityLinkPlanSetupId] [int] NOT NULL IDENTITY(1, 1),
[AllowLinkToRelatedClients] [bit] NOT NULL,
[HideMigratedPlans] [bit] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TOpportunityLinkPlanSetup_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TOpportunityLinkPlanSetup] ADD CONSTRAINT [PK_TOpportunityLinkPlanSetup] PRIMARY KEY NONCLUSTERED  ([OpportunityLinkPlanSetupId])
GO
