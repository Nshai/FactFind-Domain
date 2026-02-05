CREATE TABLE [dbo].[TFPChartAssetAllocation]
(
[FPChartAssetAllocationId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[AllocationKey] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[AllocationText] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ChartXml] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFPChartAssetAllocation_ConcurrencyId] DEFAULT ((1)),
[RiskGuid] [uniqueidentifier] NULL
)
GO
ALTER TABLE [dbo].[TFPChartAssetAllocation] ADD CONSTRAINT [PK_TFPChartAssetAllocation] PRIMARY KEY CLUSTERED  ([FPChartAssetAllocationId])
GO
