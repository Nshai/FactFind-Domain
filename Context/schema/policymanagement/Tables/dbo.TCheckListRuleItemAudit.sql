CREATE TABLE [dbo].[TCheckListRuleItemAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[Value] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[CheckListRuleId] [int] NOT NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TCheckList_ConcurrencyId_3__56] DEFAULT ((1)),
[CheckListRuleItemId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TCheckList_StampDateTime_4__56] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TCheckListRuleItemAudit] ADD CONSTRAINT [PK_TCheckListRuleItemAudit_5__56] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TCheckListRuleItemAudit_CheckListRuleItemId_ConcurrencyId] ON [dbo].[TCheckListRuleItemAudit] ([CheckListRuleItemId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
