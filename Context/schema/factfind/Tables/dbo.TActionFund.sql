CREATE TABLE [dbo].[TActionFund]
(
[ActionFundId] [int] NOT NULL IDENTITY(1, 1),
[ActionPlanId] [int] NULL,
[ManualRecommendationActionId] [int] NULL,
[FundId] [int] NULL,
[FundUnitId] [int] NULL,
[PercentageAllocation] [decimal] (18, 9) NOT NULL,
[PolicyBusinessFundId] [int] NULL,
[AddManualFundIfFundUnknown] [bit] NULL CONSTRAINT [DF_TActionFund_AddManualFundIfFundUnknown] DEFAULT ((0)),
[UnknownFundName] [varchar] (256) COLLATE Latin1_General_CI_AS NULL,
[RegularContributionPercentage] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_TActionFund_RegularContributionPercentage] DEFAULT ((0)),
[AssetFundId] [int] NULL
)
GO
ALTER TABLE [dbo].[TActionFund] ADD CONSTRAINT [PK_TActionFund] PRIMARY KEY CLUSTERED  ([ActionFundId])
GO
CREATE NONCLUSTERED INDEX IX_TActionFund_ActionPlanID ON [dbo].[TActionFund] ([ActionPlanId])
GO