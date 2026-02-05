CREATE TABLE [dbo].[TFundDefaultRisk]
(
[FundDefaultRiskId] [int] NOT NULL IDENTITY(1, 1),
[FundId] [int] NOT NULL,
[RefFundTypeId] [int] NOT NULL,
[FromFeedFg] [bit] NOT NULL,
[IndigoClientId] [int] NOT NULL,
[RiskLockedFg] [int] NULL,
[RiskProfileId] [int] NULL,
[InvestmentTypeId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFundDefaultRisk_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFundDefaultRisk] ADD CONSTRAINT [PK_TFundDefaultRisk] PRIMARY KEY NONCLUSTERED  ([FundDefaultRiskId]) WITH (FILLFACTOR=80)
GO
