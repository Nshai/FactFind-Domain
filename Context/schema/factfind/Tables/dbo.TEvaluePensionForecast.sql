CREATE TABLE [dbo].[TEvaluePensionForecast]
(
[EvaluePensionForecastId] [int] NOT NULL IDENTITY(1, 1),
[EValueLogId] [int] NULL,
[TaxYearStart] [int] NULL,
[TaxYearEnd] [int] NULL,
[EvaluePensionForecastXML] [xml] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEvaluePensionForecast_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEvaluePensionForecast] ADD CONSTRAINT [PK_TEvaluePensionForecast] PRIMARY KEY NONCLUSTERED  ([EvaluePensionForecastId])
GO
