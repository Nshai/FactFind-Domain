CREATE TABLE [dbo].[TRiskProfileAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Descriptor] [varchar] (5000) COLLATE Latin1_General_CI_AS NOT NULL,
[BriefDescription] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NOT NULL,
[RiskNumber] [int] NOT NULL,
[LowerBand] [int] NULL,
[UpperBand] [int] NULL,
[AtrTemplateGuid] [uniqueidentifier] NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TRiskProfileAudit_Guid] DEFAULT (newid()),
[ConcurrencyId] [int] NOT NULL,
[RiskProfileId] [int] NOT NULL,
[RiskProfileSyncId] [varchar] (111) CONSTRAINT [DF_TRiskProfileAudit_RiskProfileSyncId] DEFAULT (NULL),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRiskProfileAudit] ADD CONSTRAINT [PK_TRiskProfileAudit] PRIMARY KEY CLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
