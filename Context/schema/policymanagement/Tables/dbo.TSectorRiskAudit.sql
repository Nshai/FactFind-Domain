CREATE TABLE [dbo].[TSectorRiskAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CategoryId] [int] NOT NULL,
[FundTypeId] [int] NOT NULL,
[RiskProfileId] [int] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TSectorRiskAudit_Guid] DEFAULT (newid()),
[ConcurrencyId] [int] NOT NULL,
[SectorRiskId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TSectorRiskAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TSectorRiskAudit] ADD CONSTRAINT [PK_TSectorRiskAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TSectorRiskAudit_SectorRiskId_ConcurrencyId] ON [dbo].[TSectorRiskAudit] ([SectorRiskId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
