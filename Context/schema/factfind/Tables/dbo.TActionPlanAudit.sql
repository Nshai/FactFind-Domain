CREATE TABLE [dbo].[TActionPlanAudit]
(
[ActionPlanAuditId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[ScenarioId] [int] NOT NULL,
[Owner1] [int] NULL,
[Owner2] [int] NULL,
[RefPlan2ProdSubTypeId] [int] NULL,
[PercentageAllocation] [decimal] (18, 4) NOT NULL,
[PolicyBusinessId] [int] NULL,
[ActionPlanId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Contribution] [decimal] (18, 2) NULL,
[Withdrawal] [decimal] (18, 2) NULL,
[IsExecuted] [bit] NULL,
[IsOffPanel] [bit] NULL,
[PlanRecommendationCategory] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[PlanTypeThirdPartyCode] [int] NULL,
[PlanTypeThirdPartyDescription] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ProviderName] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[TopupParentPolicyBusinessId] [int] NULL,
[PlanContributionAmount] [decimal] (18, 2) NULL,
[RevisedValueDifferenceAmount] [decimal] (18, 2) NULL,
[RevisedPercentage] [decimal] (18, 9) NULL,
[IsDefault] [bit] NULL,
[IsDefaultContribution] [bit] NULL,
[SolutionGroupId] [int] NULL,
[IsNewProposal] [bit] NULL,
[SellingAdviserPartyId] [int] NULL
)
GO
ALTER TABLE [dbo].[TActionPlanAudit] ADD CONSTRAINT [PK_TActionPlanAudit] PRIMARY KEY CLUSTERED  ([ActionPlanAuditId])
GO
