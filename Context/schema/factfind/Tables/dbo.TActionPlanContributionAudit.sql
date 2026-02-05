CREATE TABLE [dbo].[TActionPlanContributionAudit]
(
[ActionPlanContributionAuditId] [int] NOT NULL IDENTITY(1, 1),
[ActionPlanContributionId] [int] NOT NULL,
[ActionPlanId] [int] NOT NULL,
[ContributionAmount] [decimal] (18, 2) NOT NULL,
[RefContributionTypeId] [int] NOT NULL,
[RefContributorTypeId] [int] NOT NULL,
[ContributionFrequency] [varchar] (2000) COLLATE Latin1_General_CI_AS NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsIncreased] [bit] NULL
)
GO
