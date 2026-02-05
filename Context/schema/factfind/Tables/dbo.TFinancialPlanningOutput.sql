CREATE TABLE [dbo].[TFinancialPlanningOutput]
(
[FinancialPlanningOutputId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[FinancialPlanningSessionId] [int] NULL,
[FinancialPlanningOutputTypeId] [int] NOT NULL,
[FinancialPlanningScenarioId] [int] NULL,
[Ordinal] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningOutput_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFinancialPlanningOutput] ADD CONSTRAINT [PK_TFinancialPlanningOutput] PRIMARY KEY CLUSTERED  ([FinancialPlanningOutputId])
GO
