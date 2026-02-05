CREATE TABLE [dbo].[TFinancialPlanningEfficientFrontierAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[ChartUrl] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Data] [varchar] (max) COLLATE Latin1_General_CI_AS NOT NULL,
[OriginalReturn] [decimal] (18, 7) NULL,
[OriginalRisk] [decimal] (18, 7) NULL,
[CurrentReturn] [decimal] (18, 7) NULL,
[CurrentRisk] [decimal] (18, 7) NULL,
[Term] [int] NULL,
[ConcurrencyId] [int] NULL,
[FinancialPlanningEfficientFrontierId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFinancialPlanningEfficientFrontierAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ChartDefinition] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningEfficientFrontierAudit] ADD CONSTRAINT [PK_TFinancialPlanningEfficientFrontierAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
