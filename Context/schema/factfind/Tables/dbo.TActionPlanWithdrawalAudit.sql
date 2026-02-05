CREATE TABLE [dbo].[TActionPlanWithdrawalAudit]
(
[ActionPlanWithdrawalAuditId] [int] NOT NULL IDENTITY(1, 1),
[ActionPlanWithdrawalId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ActionPlanId] [int] NOT NULL,
[WithdrawalAmount] [decimal] (18, 2) NOT NULL,
[WithdrawalType] [varchar] (2000) COLLATE Latin1_General_CI_AS NOT NULL,
[WithdrawalFrequency] [varchar] (2000) COLLATE Latin1_General_CI_AS NOT NULL,
[TransferDestinationActionPlanContributionId] [int] NULL,
[IsIncreased] [bit] NULL,
[IsEncashment] [bit] NULL
)
GO
