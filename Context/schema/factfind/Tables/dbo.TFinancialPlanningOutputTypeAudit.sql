CREATE TABLE [dbo].[TFinancialPlanningOutputTypeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[ToolName] [varchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[FinancialPlanningOutputTypeId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningOutputTypeAudit_ConcurrencyId] DEFAULT ((1)),
[OutputIdentifier] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningOutputTypeAudit] ADD CONSTRAINT [PK_TFinancialPlanningOutputTypeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
