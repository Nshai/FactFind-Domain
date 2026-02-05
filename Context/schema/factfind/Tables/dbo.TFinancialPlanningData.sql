CREATE TABLE [dbo].[TFinancialPlanningData]
(
[FinancialPlanningDataId] [int] NOT NULL IDENTITY(1, 1),
[DataKey] [varchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[DataValue] [varchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[FinancialPlanningOutputId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningData_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFinancialPlanningData] ADD CONSTRAINT [PK_TFinancialPlanningData] PRIMARY KEY CLUSTERED  ([FinancialPlanningDataId])
GO
