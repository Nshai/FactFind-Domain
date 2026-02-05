CREATE TABLE [dbo].[TRiskProfileCombinedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RiskProfileId] [int] NOT NULL,
[Descriptor] [varchar] (5000) COLLATE Latin1_General_CI_AS NOT NULL,
[BriefDescription] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IndigoClientId] [int] NOT NULL,
[IndigoClientGuid] [uniqueidentifier] NOT NULL,
[RiskNumber] [int] NOT NULL,
[LowerBand] [int] NULL,
[UpperBand] [int] NULL,
[AtrTemplateGuid] [uniqueidentifier] NULL,
[ConcurrencyId] [int] NOT NULL,
[Guid] [uniqueidentifier] NOT NULL CONSTRAINT [DF_TRiskProfileCombinedAudit_Guid] DEFAULT (newid()),
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRiskProfileCombinedAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRiskProfileCombinedAudit] ADD CONSTRAINT [PK_TRiskProfileCombinedAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRiskProfileCombinedAudit_Guid_ConcurrencyId] ON [dbo].[TRiskProfileCombinedAudit] ([Guid], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
