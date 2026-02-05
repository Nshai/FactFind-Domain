CREATE TABLE [dbo].[TFinancialPlanningEfficientFrontier]
(
[FinancialPlanningEfficientFrontierId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[ChartUrl] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Data] [varchar] (max) COLLATE Latin1_General_CI_AS NOT NULL,
[OriginalReturn] [decimal] (18, 7) NULL,
[OriginalRisk] [decimal] (18, 7) NULL,
[CurrentReturn] [decimal] (18, 7) NULL,
[CurrentRisk] [decimal] (18, 7) NULL,
[Term] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[ChartDefinition] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningEfficientFrontier] ADD CONSTRAINT [PK_TFinancialPlanningEfficientFrontier] PRIMARY KEY NONCLUSTERED  ([FinancialPlanningEfficientFrontierId])
GO
