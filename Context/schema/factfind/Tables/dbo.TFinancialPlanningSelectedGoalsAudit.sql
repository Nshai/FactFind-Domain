CREATE TABLE [dbo].[TFinancialPlanningSelectedGoalsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningSelectedGoalsId] [int] NOT NULL,
[FinancialPlanningId] [int] NOT NULL,
[ObjectiveId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningSelectedGoalsAudit_ConcurrencyId] DEFAULT ((0)),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFinancialPlanningSelectedGoalsAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningSelectedGoalsAudit] ADD CONSTRAINT [PK_TFinancialPlanningSelectedGoalsAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFinancialPlanningSelectedGoalsAudit_FinancialPlanningSelectedGoalsId_ConcurrencyId] ON [dbo].[TFinancialPlanningSelectedGoalsAudit] ([FinancialPlanningSelectedGoalsId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
