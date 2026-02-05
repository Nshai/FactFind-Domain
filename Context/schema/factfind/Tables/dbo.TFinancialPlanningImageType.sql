CREATE TABLE [dbo].[TFinancialPlanningImageType]
(
[FinancialPlanningImageTypeId] [int] NOT NULL IDENTITY(1, 1),
[ImageTypeName] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL,
[ImageTypeDisplayName] [varchar] (250) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningImageType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFinancialPlanningImageType] ADD CONSTRAINT [PK_TFinancialPlanningImageType] PRIMARY KEY CLUSTERED  ([FinancialPlanningImageTypeId])
GO
