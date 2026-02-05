CREATE TABLE [dbo].[TActionPlanContribution]
(
[ActionPlanContributionId] [int] NOT NULL IDENTITY(1, 1),
[ActionPlanId] [int] NOT NULL,
[ContributionAmount] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_TActionPlanContribution_Amount] DEFAULT ((0)),
[RefContributionTypeId] [int] NOT NULL,
[RefContributorTypeId] [int] NOT NULL,
[ContributionFrequency] [varchar] (2000) NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TActionPlanContribution_ConcurrencyId] DEFAULT ((1)),
[StopContribution] [bit] NOT NULL CONSTRAINT [DF_TActionPlanContribution_StopContribution] DEFAULT ((0)),
[IsIncreased] [bit] NULL
)
GO
ALTER TABLE [dbo].[TActionPlanContribution] ADD CONSTRAINT [PK_TActionPlanContribution] PRIMARY KEY CLUSTERED  ([ActionPlanContributionId])
GO
ALTER TABLE [dbo].[TActionPlanContribution] WITH CHECK ADD CONSTRAINT [FK_TActionPlanContribution_ActionPlanId_ActionPlanId] FOREIGN KEY ([ActionPlanId]) REFERENCES [dbo].[TActionPlan] ([ActionPlanId])
GO
CREATE NONCLUSTERED INDEX [IDX_TActionPlanContribution_ActionPlanId] 
ON [dbo].[TActionPlanContribution] ([ActionPlanId]) 
INCLUDE ([ContributionAmount], [RefContributionTypeId], RefContributorTypeId)
GO
