CREATE TABLE [dbo].[TOpportunityObjective]
(
[OpportunityObjectiveId] [int] NOT NULL IDENTITY(1, 1),
[OpportunityId] [int] NULL,
[ObjectiveId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TOpportunityObjective_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TOpportunityObjective] ADD CONSTRAINT [PK_TOpportunityObjective] PRIMARY KEY NONCLUSTERED  ([OpportunityObjectiveId])
GO
