CREATE TABLE [dbo].[TValProviderIndigoClientFrequencyAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
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
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValProviderIndigoClientFrequencyAudit_ConcurrencyId] DEFAULT ((0)),
[ValProviderIndigoClientFrequencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TValProviderIndigoClientFrequencyAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TValProviderIndigoClientFrequencyAudit] ADD CONSTRAINT [PK_TValProviderIndigoClientFrequencyAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TValProviderIndigoClientFrequencyAudit_ValProviderIndigoClientFrequencyId_ConcurrencyId] ON [dbo].[TValProviderIndigoClientFrequencyAudit] ([ValProviderIndigoClientFrequencyId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
