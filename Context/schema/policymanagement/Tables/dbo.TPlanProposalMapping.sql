USE [policymanagement]
GO

CREATE TABLE [dbo].[TPlanProposalMapping](
        [PlanProposalMappingId] [INT] NOT NULL IDENTITY(1, 1),
        [TenantId] [INT] NOT NULL,
        [ServiceCaseId] [INT] NOT NULL,
        [RecommendationId] [INT] NOT NULL,
        [ProposalId] [INT] NOT NULL,
        [PrimaryClientId] [INT] NOT NULL,
        [SecondaryClientId] [INT],
        [DiscriminatorName] [VARCHAR](255) NOT NULL,
        [ProviderId] [INT] NOT NULL,
        [ProviderName] [VARCHAR](255),
        [PlanTypeName] [VARCHAR](255),
        [ProposalStatusAt] [DATETIME],
        [PolicyBusinessId] [INT] NOT NULL,
        [PolicyNumber] [VARCHAR](50),
        [SequentialRef] [VARCHAR](50),
        [PlanStatus] [VARCHAR](50),
        [PlanCreationStampDateTime] [DATETIME]
)

ALTER TABLE [dbo].[TPlanProposalMapping] ADD CONSTRAINT [PK_TPlanProposalMapping] PRIMARY KEY CLUSTERED  ([PlanProposalMappingId])
GO