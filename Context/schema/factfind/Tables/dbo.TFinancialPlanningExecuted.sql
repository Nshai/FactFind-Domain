CREATE TABLE [dbo].[TFinancialPlanningExecuted]
(
[FinancialPlanningExecutedId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[DateExecuted] [datetime] NOT NULL CONSTRAINT [DF_TFinancialPlanningExecuted_DateExecuted] DEFAULT (getdate()),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningExecuted_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFinancialPlanningExecuted] ADD CONSTRAINT [PK_TFinancialPlanningExecuted] PRIMARY KEY NONCLUSTERED  ([FinancialPlanningExecutedId])
GO
