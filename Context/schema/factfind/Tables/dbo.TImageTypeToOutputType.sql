CREATE TABLE [dbo].[TImageTypeToOutputType]
(
[ImageTypeToOutputTypeId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningImageTypeId] [int] NOT NULL,
[FinancialPlanningOutputTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TImageTypeToOutputType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TImageTypeToOutputType] ADD CONSTRAINT [PK_TImageTypeToOutputType] PRIMARY KEY CLUSTERED  ([ImageTypeToOutputTypeId])
GO
