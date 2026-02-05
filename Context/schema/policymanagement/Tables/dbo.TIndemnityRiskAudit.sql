CREATE TABLE [dbo].[TIndemnityRiskAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PolicyExpectedCommissionId] [int] NOT NULL,
[IndemnityRisk] [decimal] (10, 2) NOT NULL CONSTRAINT [DF_TIndemnityRiskAudit_IndemnityRisk] DEFAULT ((0.00)),
[InForceDate] [datetime] NULL,
[ChargingPeriod] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIndemnityRiskAudit_ConcurrencyId] DEFAULT ((1)),
[IndemnityRiskId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TIndemnityRiskAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TIndemnityRiskAudit] ADD CONSTRAINT [PK_TIndemnityRiskAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TIndemnityRiskAudit_IndemnityRiskId_ConcurrencyId] ON [dbo].[TIndemnityRiskAudit] ([IndemnityRiskId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
