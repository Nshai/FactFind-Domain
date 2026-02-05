CREATE TABLE [dbo].[TServiceCaseToOpportunity]
(
[ServiceCaseToOpportunityId] [int] NOT NULL IDENTITY(1, 1),
[OpportunityId] [int] NOT NULL,
[AdviceCaseId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TServiceCaseToOpportunity_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TServiceCaseToOpportunity] ADD CONSTRAINT [PK_TServiceCaseToOpportunity] PRIMARY KEY NONCLUSTERED  ([ServiceCaseToOpportunityId])
GO
CREATE NONCLUSTERED INDEX [IDX_TServiceCaseToOpportunity_AdviceCaseId] 
ON [dbo].[TServiceCaseToOpportunity] ([AdviceCaseId]) 
INCLUDE ([OpportunityId])
GO
CREATE NONCLUSTERED INDEX IDX_TServiceCaseToOpportunity_OpportunityId
ON dbo.TServiceCaseToOpportunity (OpportunityId)
GO