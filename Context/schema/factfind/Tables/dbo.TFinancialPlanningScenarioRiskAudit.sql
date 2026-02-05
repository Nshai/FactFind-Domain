CREATE TABLE [dbo].[TFinancialPlanningScenarioRiskAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NULL,
[ScenarioId] [int] NULL,
[RiskDescription] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RiskNumber] [int] NULL,
[ConcurrencyId] [int] NULL,
[FinancialPlanningScenarioRiskId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFinancialPlanningScenarioRiskAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningScenarioRiskAudit] ADD CONSTRAINT [PK_TFinancialPlanningScenarioRiskAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
