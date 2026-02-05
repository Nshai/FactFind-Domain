CREATE TABLE [dbo].[TFinancialPlanningActiveScenarioAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[FinancialPlanningScenarioId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningActiveScenarioAudit_ConcurrencyId] DEFAULT ((1)),
[FinancialPlanningActiveScenarioId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFinancialPlanningActiveScenarioAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningActiveScenarioAudit] ADD CONSTRAINT [PK_TFinancialPlanningActiveScenarioAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
