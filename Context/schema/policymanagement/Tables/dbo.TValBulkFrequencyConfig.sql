CREATE TABLE [dbo].[TValBulkFrequencyConfig]
(
[ValBulkFrequencyConfigId] [int] NOT NULL IDENTITY(1, 1),
[ValuationProviderId] [int] NOT NULL,
[AllowDaily] [bit] NOT NULL,
[AllowWeekly] [bit] NOT NULL,
[AllowFortnightly] [bit] NOT NULL,
[AllowMonthly] [bit] NOT NULL,
[AllowBiAnnually] [bit] NOT NULL,
[AllowQuarterly] [bit] NOT NULL,
[AllowHalfYearly] [bit] NOT NULL,
[AllowAnnually] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValBulkFrequencyConfig_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TValBulkFrequencyConfig] ADD CONSTRAINT [PK_TValBulkFrequencyConfig] PRIMARY KEY CLUSTERED  ([ValBulkFrequencyConfigId])
GO
