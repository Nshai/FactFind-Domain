CREATE TABLE [dbo].[TValProviderIndigoClientFrequency]
(
[ValProviderIndigoClientFrequencyId] [int] NOT NULL IDENTITY(1, 1),
[RefProdProviderId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[AllowDaily] [tinyint] NOT NULL,
[AllowWeekly] [tinyint] NOT NULL,
[AllowFortnightly] [tinyint] NOT NULL,
[AllowMonthly] [tinyint] NOT NULL,
[AllowBiAnnually] [tinyint] NOT NULL,
[AllowQuarterly] [tinyint] NOT NULL,
[AllowHalfYearly] [tinyint] NOT NULL,
[AllowAnnually] [tinyint] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValProviderIndigoClientFrequency_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TValProviderIndigoClientFrequency] ADD CONSTRAINT [PK_TValProviderIndigoClientFrequency] PRIMARY KEY NONCLUSTERED  ([ValProviderIndigoClientFrequencyId])
GO
