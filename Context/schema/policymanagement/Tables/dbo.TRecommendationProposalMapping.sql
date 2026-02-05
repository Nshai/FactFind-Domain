/*Temporary  table created for Rollback strategy of DEF-17871 and
will be deleted once customer confirms the fix is working fine
*/

USE [policymanagement]
GO

CREATE TABLE [dbo].[TRecommendationProposalMapping](
        [RecommendationProposalMappingId] [INT] NOT NULL IDENTITY(1, 1),
        [ProposalId] [INT] NOT NULL,
        [RecommendationId] [INT] NOT NULL,
        [TenantId] [INT] NOT NULL,
)

ALTER TABLE [dbo].[TRecommendationProposalMapping] ADD CONSTRAINT [PK_TRecommendationProposalMapping] PRIMARY KEY CLUSTERED  ([RecommendationProposalMappingId])
GO