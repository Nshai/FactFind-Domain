CREATE TABLE [dbo].[TEvalueCashflowToGoalCategoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RefEvalueCashflowTypeId] [int] NOT NULL,
[RefGoalCategoryId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[EvalueCashflowToGoalCategoryId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [date] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEvalueCashflowToGoalCategoryAudit] ADD CONSTRAINT [PK_TEvalueCashflowToGoalCategoryAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
