CREATE TABLE [dbo].[TCheckListRule]
(
[CheckListRuleId] [int] NOT NULL IDENTITY(1, 1),
[CheckListId] [int] NOT NULL,
[RefPlanTypeId] [int] NOT NULL,
[ComplianceReferral] [bit] NOT NULL,
[Always] [bit] NOT NULL,
[AnyItem] [bit] NOT NULL,
[RuleBusinessType] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCheckList_ConcurrencyId_1__70] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TCheckListRule] ADD CONSTRAINT [PK_TCheckListRule_2__70] PRIMARY KEY NONCLUSTERED  ([CheckListRuleId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TCheckListRule_CheckListId] ON [dbo].[TCheckListRule] ([CheckListId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TCheckListRule_RefPlanTypeId] ON [dbo].[TCheckListRule] ([RefPlanTypeId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TCheckListRule] ADD CONSTRAINT [FK_TCheckListRule_CheckListId_CheckListId] FOREIGN KEY ([CheckListId]) REFERENCES [dbo].[TCheckList] ([CheckListId])
GO
ALTER TABLE [dbo].[TCheckListRule] ADD CONSTRAINT [FK_TCheckListRule_RefPlanTypeId_RefPlanTypeId] FOREIGN KEY ([RefPlanTypeId]) REFERENCES [dbo].[TRefPlanType] ([RefPlanTypeId])
GO
