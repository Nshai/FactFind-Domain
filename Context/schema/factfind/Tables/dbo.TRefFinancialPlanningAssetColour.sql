CREATE TABLE [dbo].[TRefFinancialPlanningAssetColour]
(
[RefFinancialPlanningAssetColourId] [int] NOT NULL IDENTITY(1, 1),
[AssetDescription] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AssetSeriesNumber] [int] NULL,
[AssetColour] [varchar] (7) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TRefFinancialPlanningAssetColour] ADD CONSTRAINT [PK_TRefFinancialPlanningAssetColour] PRIMARY KEY NONCLUSTERED  ([RefFinancialPlanningAssetColourId])
GO
