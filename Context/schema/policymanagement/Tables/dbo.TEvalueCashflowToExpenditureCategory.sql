CREATE TABLE [dbo].[TEvalueCashflowToExpenditureCategory]
(
[EvalueCashflowToExpenditureCategoryId] [int] NOT NULL IDENTITY(1, 1),
[RefExpenditureTypeId] [int] NOT NULL,
[RefEvalueCashflowTypeId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TEvalueCashflowToExpenditureCategory] ADD CONSTRAINT [PK_TEvalueToExpenditure] PRIMARY KEY CLUSTERED  ([EvalueCashflowToExpenditureCategoryId])
GO
