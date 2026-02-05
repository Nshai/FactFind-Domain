CREATE TABLE [dbo].[TLifeCycleTransitionToLifeCycleTransitionRuleAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[LifeCycleTransitionId] [int] NOT NULL,
[LifeCycleTransitionRuleId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLifeCycleTransitionToLifeCycleTransitionRuleAudit_ConcurrencyId] DEFAULT ((1)),
[LifeCycleTransitionToLifeCycleTransitionRuleId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TLifeCycleTransitionToLifeCycleTransitionRuleAudit] ADD CONSTRAINT [PK_TLifeCycleTransitionToLifeCycleTransitionRuleAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
