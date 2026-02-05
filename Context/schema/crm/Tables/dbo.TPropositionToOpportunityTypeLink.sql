CREATE TABLE [dbo].[TPropositionToOpportunityTypeLink]
(
[PropositionToOpportunityTypeLinkId] [int] NOT NULL IDENTITY(1, 1),
[PropositionTypeId] [int] NOT NULL,
[OpportunityTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPropositionToOpportunityTypeLink_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPropositionToOpportunityTypeLink] ADD CONSTRAINT [PK_TPropositionToOpportunityTypeLink] PRIMARY KEY NONCLUSTERED  ([PropositionToOpportunityTypeLinkId])
GO
