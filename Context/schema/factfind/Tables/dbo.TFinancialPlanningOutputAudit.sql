CREATE TABLE [dbo].[TFinancialPlanningOutputAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[FinancialPlanningSessionId] [int] NULL,
[FinancialPlanningOutputTypeId] [int] NOT NULL,
[FinancialPlanningScenarioId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningOutputAudit_ConcurrencyId] DEFAULT ((1)),
[Ordinal] [int] NULL,
[FinancialPlanningOutputId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFinancialPlanningOutputAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningOutputAudit] ADD CONSTRAINT [PK_TFinancialPlanningOutputAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
