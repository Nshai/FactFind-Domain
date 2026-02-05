CREATE TABLE [dbo].[TFundProposal]
(
[FundProposalId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[FundUnitId] [int] NOT NULL,
[IsFromSeed] [bit] NOT NULL,
[Percentage] [decimal] (18, 5) NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFundProposal_ConcurrencyId] DEFAULT ((1)),
[RegularContributionPercentage] [decimal] (18, 5) NOT NULL CONSTRAINT [DF_TFundProposal_RegularContributionPercentage] DEFAULT ((0)),
[IsEquity] [bit] NOT NULL CONSTRAINT [DF_TFundProposal_IsEquity] DEFAULT ((0)),
[FundId] AS (CASE WHEN IsEquity = 1 then 'E' WHEN IsFromSeed = 1 then 'F' WHEN IsFromSeed = 0 then 'M' end + CONVERT([varchar](10),[FundUnitId],(0))) PERSISTED
)
GO
ALTER TABLE [dbo].[TFundProposal] ADD CONSTRAINT [PK_TFundProposal] PRIMARY KEY CLUSTERED  ([FundProposalId])
GO
CREATE NONCLUSTERED INDEX [IX_TFundProposal_PolicyBusinessId] ON [dbo].[TFundProposal] ([PolicyBusinessId])
CREATE NONCLUSTERED INDEX [IX_TFundProposal_TenantId] ON [dbo].[TFundProposal] ([TenantId])
GO
