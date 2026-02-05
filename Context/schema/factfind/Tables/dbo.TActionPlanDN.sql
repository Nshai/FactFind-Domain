CREATE TABLE [dbo].[TActionPlanDN]
(
[ActionPlanDNId] [int] NOT NULL IDENTITY(1, 1),
[ActionPlanId] [int] NOT NULL,
[SingleLumpSum] [money] NULL,
[MonthlyContribution] [money] NULL,
[AnnualWithdrawal] [money] NULL,
[Owner1] [int] NULL,
[Owner2] [int] NULL,
[RefPlan2ProdSubTypeId] [int] NULL,
[MasterPolicyBusinessId] [int] NULL,
[IsSwitch] [bit] NULL,
[StartDate] [datetime] NULL,
[TargetDate] [datetime] NULL,
[HasWithdrawalPercentage] [bit] NULL CONSTRAINT [DF_TActionPlanDN_HasWithdrawalPercentage] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TActionPlanDN] ADD CONSTRAINT [PK_TActionPlanDN] PRIMARY KEY CLUSTERED  ([ActionPlanDNId])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_TActionPlanDN] ON [dbo].[TActionPlanDN] ([ActionPlanId])
GO
