CREATE TABLE [dbo].[TFundProposalAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[FundUnitId] [int] NOT NULL,
[IsFromSeed] [bit] NOT NULL,
[Percentage] [decimal] (18, 5) NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFundProposalAudit_ConcurrencyId] DEFAULT ((1)),
[FundProposalId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RegularContributionPercentage] [decimal] (18, 5) NOT NULL CONSTRAINT [DF_TFundProposalAudit_RegularContributionPercentage] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TFundProposalAudit] ADD CONSTRAINT [PK_TFundProposalAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
