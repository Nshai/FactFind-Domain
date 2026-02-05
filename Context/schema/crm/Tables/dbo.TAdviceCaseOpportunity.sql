CREATE TABLE [dbo].[TAdviceCaseOpportunity]
(
[AdviceCaseOpportunityId] [int] NOT NULL IDENTITY(1, 1),
[AdviceCaseId] [int] NOT NULL,
[OpportunityId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviceCaseOpportunity_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAdviceCaseOpportunity] ADD CONSTRAINT [PK_TAdviceCaseOpportunity] PRIMARY KEY NONCLUSTERED  ([AdviceCaseOpportunityId])
GO
