CREATE TABLE [dbo].[TAdviceCaseAutoCloseStatusRuleAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[NumberOfDays] [int] NULL,
[AdviceCaseAutoCloseRule] [int] NOT NULL CONSTRAINT [DF_TAdviceCaseAutoCloseStatusRuleAudit_AdviceCaseAutoCloseRule_1] DEFAULT ((0)),
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdviceCaseAutoCloseStatusRuleAudit_ConcurrencyId] DEFAULT ((1)),
[AdviceCaseAutoCloseStatusRuleId] [int] NOT NULL CONSTRAINT [DF_TAdviceCaseAutoCloseStatusRuleAudit_AdviceCaseAutoCloseRule] DEFAULT ((0)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TAdviceCaseAutoCloseStatusRuleAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[HasReopenRule] [bit] NULL,
[ReopenNumberOfDays] [int] NULL
)
GO
ALTER TABLE [dbo].[TAdviceCaseAutoCloseStatusRuleAudit] ADD CONSTRAINT [PK_TAdviceCaseAutoCloseStatusRuleAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
