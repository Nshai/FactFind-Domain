CREATE TABLE [dbo].[TFundDefaultRiskAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FundId] [int] NOT NULL,
[RefFundTypeId] [int] NOT NULL,
[FromFeedFg] [bit] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[RiskLockedFg] [int] NULL,
[RiskProfileId] [int] NULL,
[InvestmentTypeId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFundDefaultRiskAudit_ConcurrencyId] DEFAULT ((1)),
[FundDefaultRiskId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFundDefaultRiskAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFundDefaultRiskAudit] ADD CONSTRAINT [PK_TFundDefaultRiskAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TFundDefaultRiskAudit_FundDefaultRiskId_ConcurrencyId] ON [dbo].[TFundDefaultRiskAudit] ([FundDefaultRiskId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
