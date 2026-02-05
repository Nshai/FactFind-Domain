CREATE TABLE [dbo].[TRefPensionForecast]
(
[RefPensionForecastId] [int] NOT NULL IDENTITY(1, 1),
[RefPensionForecastDescription] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPensionForecast_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TRefPensionForecast] ADD CONSTRAINT [PK_TRefPensionForecast] PRIMARY KEY NONCLUSTERED  ([RefPensionForecastId])
GO
