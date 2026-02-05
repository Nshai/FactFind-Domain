CREATE TABLE [dbo].[TEvalueCashflowToExpenditureCategoryAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[EvalueCashflowToExpenditureCategoryId] [int] NULL,
[RefExpenditureTypeId] [int] NULL,
[RefEvalueCashflowTypeId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEvalueCashflowToExpenditureCategoryAudit] ADD CONSTRAINT [PK_TEvalueCashflowToExpenditureCategoryAudit__AuditId] PRIMARY KEY CLUSTERED  ([AuditId])
GO
