CREATE TABLE [dbo].[TCheckListRuleItem]
(
[CheckListRuleItemId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[Value] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL,
[CheckListRuleId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCheckList_ConcurrencyId_3__84] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TCheckListRuleItem] ADD CONSTRAINT [PK_TCheckListRuleItem_5__84] PRIMARY KEY NONCLUSTERED  ([CheckListRuleItemId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TCheckListRuleItem_CheckListRuleId] ON [dbo].[TCheckListRuleItem] ([CheckListRuleId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TCheckListRuleItem] ADD CONSTRAINT [FK_TCheckListRuleItem_CheckListRuleId_CheckListRuleId] FOREIGN KEY ([CheckListRuleId]) REFERENCES [dbo].[TCheckListRule] ([CheckListRuleId])
GO
