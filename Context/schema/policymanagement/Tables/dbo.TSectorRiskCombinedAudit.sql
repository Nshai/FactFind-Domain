CREATE TABLE [dbo].[TSectorRiskCombinedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[SectorRiskId] [int] NOT NULL,
[CategoryId] [int] NOT NULL,
[FundTypeId] [int] NOT NULL,
[RiskProfileId] [int] NOT NULL,
[RiskProfileGuid] [uniqueidentifier] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TSectorRiskCombinedAudit_Guid] DEFAULT (newid()),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TSectorRiskCombinedAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TSectorRiskCombinedAudit] ADD CONSTRAINT [PK_TSectorRiskCombinedAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TSectorRiskCombinedAudit_Guid_ConcurrencyId] ON [dbo].[TSectorRiskCombinedAudit] ([Guid], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
