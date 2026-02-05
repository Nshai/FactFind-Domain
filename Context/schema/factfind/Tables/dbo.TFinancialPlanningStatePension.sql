CREATE TABLE [dbo].[TFinancialPlanningStatePension]
(
[FinancialPlanningStatePensionId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[RefPensionForecastId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningStatePension_RefPensionForecastId] DEFAULT ((1)),
[BasicAnnualAmount] [money] NOT NULL CONSTRAINT [DF_TFinancialPlanningStatePension_BasicAnnualAmount] DEFAULT ((0)),
[AdditionalAnnualAmount] [money] NOT NULL CONSTRAINT [DF_TFinancialPlanningStatePension_AdditionalAnnualAmount] DEFAULT ((0)),
[TaxYearStartWork] [int] NULL,
[TaxYearFinishWork] [int] NULL,
[AnnualSalary] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningStatePension_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TFinancialPlanningStatePension] ADD CONSTRAINT [PK_TFinancialPlanningStatePension] PRIMARY KEY CLUSTERED  ([FinancialPlanningStatePensionId])
GO
