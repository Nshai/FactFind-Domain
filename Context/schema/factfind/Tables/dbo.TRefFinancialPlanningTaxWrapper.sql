CREATE TABLE [dbo].[TRefFinancialPlanningTaxWrapper]
(
[RefFinancialPlanningTaxWrapperId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[IsPension] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefFinancialPlanningTaxWrapper_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefFinancialPlanningTaxWrapper] ADD CONSTRAINT [PK_TRefFinancialPlanningTaxWrapper] PRIMARY KEY CLUSTERED  ([RefFinancialPlanningTaxWrapperId])
GO
