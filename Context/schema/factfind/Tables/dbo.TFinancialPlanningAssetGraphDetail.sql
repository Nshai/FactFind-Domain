CREATE TABLE [dbo].[TFinancialPlanningAssetGraphDetail]
(
[FinancialPlanningAssetGraphDetailId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[Data] [varchar] (max) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningAssetGraphDetail_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFinancialPlanningAssetGraphDetail] ADD CONSTRAINT [PK_TFinancialPlanningAssetGraphDetail] PRIMARY KEY CLUSTERED  ([FinancialPlanningAssetGraphDetailId])
GO
