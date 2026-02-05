CREATE TABLE [dbo].[TFinancialPlanningToolsSessionAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NULL,
[ConcurrencyId] [int] NULL,
[BaseTemplateGuid] [uniqueidentifier] NULL,
[AtrRefProfilePreferenceId] [int] NULL,
[FinancialPlanningToolsSessionId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningToolsSessionAudit] ADD CONSTRAINT [PK_TFinancialPlanningToolsSessionAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
