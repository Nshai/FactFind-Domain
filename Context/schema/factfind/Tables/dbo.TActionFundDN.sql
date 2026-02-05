CREATE TABLE [dbo].[TActionFundDN]
(
[ActionFundDNId] [int] NOT NULL IDENTITY(1, 1),
[ActionPlanId] [int] NOT NULL,
[ActionFundId] [int] NOT NULL,
[FundId] [int] NULL,
[FundUnitId] [int] NULL,
[PercentageAllocation] [decimal] (18, 2) NOT NULL,
[IsFromFeed] [bit] NOT NULL CONSTRAINT [DF_TActionFundDN_IsFromFeed] DEFAULT ((0)),
[AddManualFundIfFundUnknown] [bit] NULL CONSTRAINT [DF_TActionFundDN_AddManualFundIfFundUnknown] DEFAULT ((0)),
[UnknownFundName] [varchar] (256) COLLATE Latin1_General_CI_AS NULL,
[RegularContributionPercentage] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_TActionFundDN_RegularContributionPercentage] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TActionFundDN] ADD CONSTRAINT [PK_TActionFundDN] PRIMARY KEY NONCLUSTERED ([ActionFundDNId])
GO
CREATE NONCLUSTERED INDEX IX_TActionFundDN_ActionPlanId_ActionFundId ON [dbo].[TActionFundDN] ([ActionPlanId],[ActionFundId])
GO
