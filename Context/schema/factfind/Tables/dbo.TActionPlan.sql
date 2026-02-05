CREATE TABLE [dbo].[TActionPlan]
(
[ActionPlanId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[ScenarioId] [int] NOT NULL,
[Owner1] [int] NULL,
[Owner2] [int] NULL,
[RefPlan2ProdSubTypeId] [int] NULL,
[PercentageAllocation] [decimal] (18, 9) NOT NULL,
[PolicyBusinessId] [int] NULL,
[Contribution] [decimal] (18, 2) NULL CONSTRAINT [DF_TActionPlan_Contribution] DEFAULT ((0)),
[Withdrawal] [decimal] (18, 2) NULL,
[IsExecuted] [bit] NULL CONSTRAINT [DF_TActionPlan_IsExecuted] DEFAULT ((0)),
[IsOffPanel] [bit] NULL,
[RefPlanTypeId] [int] NULL,
[PlanRecommendationCategory] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[PlanTypeThirdPartyCode] [int] NULL,
[PlanTypeThirdPartyDescription] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ProviderName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[TopupParentPolicyBusinessId] [int] NULL,
[PlanContributionAmount] [decimal] (18, 2) NULL,
[RevisedValueDifferenceAmount] [decimal] (18, 2) NULL CONSTRAINT [DF_TActionPlan_RevisedValueDifferenceAmount] DEFAULT ((0)),
[RevisedPercentage] [decimal] (18, 9) NULL CONSTRAINT [DF_TActionPlan_RevisedPercentage] DEFAULT ((0)),
[IsDefault] [bit] NULL CONSTRAINT [DF_TActionPlan_IsDefault] DEFAULT ((0)),
[IsDefaultContribution] [bit] NULL CONSTRAINT [DF_TActionPlan_IsDefaultContribution] DEFAULT ((0)),
[SolutionGroupId] [int] NULL,
[IsNewProposal] [bit] NULL,
[QuoteId] [int] NULL,
[SellingAdviserPartyId] [int] NULL,
[StatusReasonId] [int] NULL,
[ModelPortfolioId] [int] NULL
)
GO
ALTER TABLE [dbo].[TActionPlan] ADD CONSTRAINT [PK_TActionPlan] PRIMARY KEY CLUSTERED  ([ActionPlanId])
GO
CREATE NONCLUSTERED INDEX [IX_TActionPlan_FinancialPlanningId_ScenarioId] ON [dbo].[TActionPlan] ([FinancialPlanningId], [ScenarioId])
GO
CREATE NONCLUSTERED INDEX IX_TActionPlan_ScenarioId ON [dbo].[TActionPlan] ([ScenarioId]) INCLUDE ([TopupParentPolicyBusinessId],[IsNewProposal])
GO
