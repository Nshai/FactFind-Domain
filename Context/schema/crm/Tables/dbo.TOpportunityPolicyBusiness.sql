CREATE TABLE [dbo].[TOpportunityPolicyBusiness]
(
[OpportunityPolicyBusinessId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[OpportunityId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TOpportunityPolicyBusiness_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TOpportunityPolicyBusiness] ADD CONSTRAINT [PK_TOpportunityPolicyBusiness] PRIMARY KEY CLUSTERED  ([OpportunityPolicyBusinessId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX IX_TOpportunityPolicyBusiness_PolicyBusinessId ON [dbo].[TOpportunityPolicyBusiness] ([PolicyBusinessId])
GO