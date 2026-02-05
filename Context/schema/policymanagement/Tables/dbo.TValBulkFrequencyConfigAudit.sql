CREATE TABLE [dbo].[TValBulkFrequencyConfigAudit]
(
[ValBulkFrequencyConfigAuditId] [int] NOT NULL IDENTITY(1, 1),
[ValuationProviderId] [int] NOT NULL,
[AllowDaily] [bit] NOT NULL,
[AllowWeekly] [bit] NOT NULL,
[AllowFortnightly] [bit] NOT NULL,
[AllowMonthly] [bit] NOT NULL,
[AllowBiAnnually] [bit] NOT NULL,
[AllowQuarterly] [bit] NOT NULL,
[AllowHalfYearly] [bit] NOT NULL,
[AllowAnnually] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[ValBulkFrequencyConfigId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TValBulkFrequencyConfigAudit] ADD CONSTRAINT [PK_TValBulkFrequencyConfigAudit] PRIMARY KEY CLUSTERED  ([ValBulkFrequencyConfigAuditId])
GO
