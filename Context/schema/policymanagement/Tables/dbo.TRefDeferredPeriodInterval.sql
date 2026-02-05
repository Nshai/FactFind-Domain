CREATE TABLE [dbo].[TRefDeferredPeriodInterval]
(
[RefDeferredPeriodIntervalId] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
