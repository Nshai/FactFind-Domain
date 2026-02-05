CREATE TABLE [dbo].[TRefRuleCategory]
(
[RefRuleCategoryId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TRefRuleCategory_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefRuleCategory] ADD CONSTRAINT [PK_TRefRuleCategory] PRIMARY KEY CLUSTERED  ([RefRuleCategoryId])
GO
