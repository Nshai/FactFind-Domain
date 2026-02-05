CREATE TABLE [dbo].[TAdviceCaseStatusTransitionRuleAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[AdviceCaseStatusChangeId] [int] NOT NULL,
[AdviceCaseStatusRuleId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviceCaseStatusTransitionRuleAudit_ConcurrencyId] DEFAULT ((1)),
[AdviceCaseStatusTransitionRuleId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAdviceCaseStatusTransitionRuleAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAdviceCaseStatusTransitionRuleAudit] ADD CONSTRAINT [PK_TAdviceCaseStatusTransitionRuleAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
