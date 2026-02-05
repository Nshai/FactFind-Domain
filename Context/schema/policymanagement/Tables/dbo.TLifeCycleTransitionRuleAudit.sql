CREATE TABLE [dbo].[TLifeCycleTransitionRuleAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[Name] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[Code] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (500) COLLATE Latin1_General_CI_AS NOT NULL,
[SpName] [varchar] (150) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[LifeCycleTransitionRuleId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RefLifecycleRuleCategoryId] [int] NULL
)
GO
ALTER TABLE [dbo].[TLifeCycleTransitionRuleAudit] ADD CONSTRAINT [PK_TLifeCycleTransitionRuleAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
