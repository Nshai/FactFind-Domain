CREATE TABLE [dbo].[TFinancialPlanningAssetTableDetail]
(
[FinancialPlanningAssetTableDetailId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[AssetAllocationTableDetail] [varchar] (max) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningAssetTableDetail] ADD CONSTRAINT [PK_TFinancialPlanningAssetTableDetail] PRIMARY KEY CLUSTERED  ([FinancialPlanningAssetTableDetailId])
GO
