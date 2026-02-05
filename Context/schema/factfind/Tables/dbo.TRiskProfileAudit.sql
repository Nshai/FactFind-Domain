CREATE TABLE [dbo].[TRiskProfileAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (30) COLLATE Latin1_General_CI_AS NOT NULL,
[Description] [varchar] (500) COLLATE Latin1_General_CI_AS NULL,
[LowerBand] [int] NULL,
[UpperBand] [int] NULL,
[Ordinal] [tinyint] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRiskProfileAudit_ConcurrencyId] DEFAULT ((1)),
[RiskProfileId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRiskProfileAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRiskProfileAudit] ADD CONSTRAINT [PK_TRiskProfileAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRiskProfileAudit_RiskProfileId_ConcurrencyId] ON [dbo].[TRiskProfileAudit] ([RiskProfileId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
