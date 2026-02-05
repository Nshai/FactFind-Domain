CREATE TABLE [dbo].[TEvalueCashflowToGoalCategory]
(
[EvalueCashflowToGoalCategoryId] [int] NOT NULL IDENTITY(1, 1),
[RefEvalueCashflowTypeId] [int] NOT NULL,
[RefGoalCategoryId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEvalueCashflowToGoalCategory_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEvalueCashflowToGoalCategory] ADD CONSTRAINT [PK_TEvalueCashflowToGoalCategory] PRIMARY KEY CLUSTERED  ([EvalueCashflowToGoalCategoryId])
GO
