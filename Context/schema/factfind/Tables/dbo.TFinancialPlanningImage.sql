CREATE TABLE [dbo].[TFinancialPlanningImage]
(
[FinancialPlanningImageId] [int] NOT NULL IDENTITY(1, 1),
[ImageData] [varbinary] (max) NOT NULL,
[FinancialPlanningOutputId] [int] NOT NULL,
[FinancialPlanningImageTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningImage_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFinancialPlanningImage] ADD CONSTRAINT [PK_TFinancialPlanningImage] PRIMARY KEY CLUSTERED  ([FinancialPlanningImageId])
GO
