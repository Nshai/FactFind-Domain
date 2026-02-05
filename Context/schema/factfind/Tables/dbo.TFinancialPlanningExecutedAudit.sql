CREATE TABLE [dbo].[TFinancialPlanningExecutedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[DateExecuted] [datetime] NOT NULL CONSTRAINT [DF_TFinancialPlanningExecutedAudit_DateExecuted] DEFAULT (getdate()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningExecutedAudit_ConcurrencyId] DEFAULT ((1)),
[FinancialPlanningExecutedId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFinancialPlanningExecutedAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningExecutedAudit] ADD CONSTRAINT [PK_TFinancialPlanningExecutedAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFinancialPlanningExecutedAudit_FinancialPlanningExecutedId_ConcurrencyId] ON [dbo].[TFinancialPlanningExecutedAudit] ([FinancialPlanningExecutedId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
