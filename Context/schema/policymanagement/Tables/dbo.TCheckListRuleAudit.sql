CREATE TABLE [dbo].[TCheckListRuleAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CheckListId] [int] NOT NULL,
[RefPlanTypeId] [int] NOT NULL,
[ComplianceReferral] [bit] NULL,
[Always] [bit] NULL,
[AnyItem] [bit] NULL,
[RuleBusinessType] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCheckList_ConcurrencyId_2__56] DEFAULT ((1)),
[CheckListRuleId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TCheckList_StampDateTime_3__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TCheckListRuleAudit] ADD CONSTRAINT [PK_TCheckListRuleAudit_4__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TCheckListRuleAudit_CheckListRuleId_ConcurrencyId] ON [dbo].[TCheckListRuleAudit] ([CheckListRuleId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
