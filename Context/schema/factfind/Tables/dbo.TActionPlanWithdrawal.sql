CREATE TABLE [dbo].[TActionPlanWithdrawal]
(
[ActionPlanWithdrawalId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TActionPlanWithdrawal_ConcurrencyId] DEFAULT ((1)),
[ActionPlanId] [int] NOT NULL,
[WithdrawalAmount] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_TActionPlanWithdrawal_Amount] DEFAULT ((0)),
[WithdrawalType] [varchar] (2000) NOT NULL,
[WithdrawalFrequency] [varchar] (2000) NOT NULL,
[TransferDestinationActionPlanContributionId] [int] NULL,
[IsIncreased] [bit] NULL,
[IsEncashment] [bit] NULL
)
GO
ALTER TABLE [dbo].[TActionPlanWithdrawal] ADD CONSTRAINT [PK_TActionPlanWithdrawal] PRIMARY KEY CLUSTERED  ([ActionPlanWithdrawalId])
GO
CREATE NONCLUSTERED INDEX IX_TActionPlanWithdrawal_ActionPlanId ON [dbo].TActionPlanWithdrawal (ActionPlanId) -- 164206              
INCLUDE ([WithdrawalAmount],[WithdrawalType],[WithdrawalFrequency],[IsIncreased],[IsEncashment])
GO
ALTER TABLE [dbo].[TActionPlanWithdrawal] WITH CHECK ADD CONSTRAINT [FK_TActionPlanWithdrawal_ActionPlanId_ActionPlanId] FOREIGN KEY ([ActionPlanId]) REFERENCES [dbo].[TActionPlan] ([ActionPlanId])
GO
ALTER TABLE [dbo].[TActionPlanWithdrawal] ADD CONSTRAINT [FK_TActionPlanWithdrawal_TActionPlanContribution] FOREIGN KEY ([TransferDestinationActionPlanContributionId]) REFERENCES [dbo].[TActionPlanContribution] ([ActionPlanContributionId])
GO
