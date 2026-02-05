CREATE TABLE [dbo].[TAdviceCaseStatusRuleAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RuleDescriptor] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ActionDescriptor] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IsArchived] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviceCaseStatusRuleAudit_ConcurrencyId] DEFAULT ((1)),
[AdviceCaseStatusRuleId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAdviceCaseStatusRuleAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAdviceCaseStatusRuleAudit] ADD CONSTRAINT [PK_TAdviceCaseStatusRuleAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
