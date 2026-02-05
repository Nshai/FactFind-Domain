CREATE TABLE [dbo].[TActionFundAudit]
(
[ActionFundAuditId] [int] NOT NULL IDENTITY(1, 1),
[ActionPlanId] [int] NULL,
[ManualRecommendationActionId] [int] NULL,
[FundId] [int] NULL,
[FundUnitId] [int] NULL,
[PercentageAllocation] [decimal] (18, 9) NOT NULL,
[PolicyBusinessFundId] [int] NULL,
[ActionFundId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[AddManualFundIfFundUnknown] [bit] NULL,
[UnknownFundName] [varchar] (256) COLLATE Latin1_General_CI_AS NULL,
[RegularContributionPercentage] [decimal] (18, 2) NULL,
[AssetFundId] [int] NULL
)
GO
ALTER TABLE [dbo].[TActionFundAudit] ADD CONSTRAINT [PK_TActionFundAudit] PRIMARY KEY CLUSTERED  ([ActionFundAuditId])
GO
