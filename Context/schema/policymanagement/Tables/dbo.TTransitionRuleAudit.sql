CREATE TABLE [dbo].[TTransitionRuleAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RuleSPName] [varchar] (128) COLLATE Latin1_General_CI_AS NOT NULL,
[LifeCycleTransitionId] [int] NOT NULL,
[Alias] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TTransitionRuleAudit_ConcurrencyId] DEFAULT ((1)),
[TransitionRuleId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TTransitionRuleAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TTransitionRuleAudit] ADD CONSTRAINT [PK_TTransitionRuleAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
