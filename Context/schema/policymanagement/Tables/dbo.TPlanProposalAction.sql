USE [policymanagement]
GO

CREATE TABLE [dbo].[TPlanProposalAction](
	[PlanProposalActionId] [int] IDENTITY(1,1) NOT NULL,
	[PlanId] [int] NULL,
	[RecommendationProposalId] [int] NULL,
	[RecommendationProposalType] [varchar](255) NULL
	)
GO

ALTER TABLE [dbo].[TPlanProposalAction] ADD CONSTRAINT [PK_TPlanProposalAction] PRIMARY KEY CLUSTERED  ([PlanProposalActionId])
GO