CREATE TABLE [dbo].[TFeeContributionBreakupAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FeeId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[NetAmount] [decimal] (18, 2) NULL,
[DiscountAmount] [decimal] (18, 2) NULL,
[VATAmount] [decimal] (18, 2) NULL,
[TotalRegularContribution] [decimal] (18, 2) NULL,
[TotalLumpsumContribution] [decimal] (18, 2) NULL,
[TotalFeeAmount] [decimal] (18, 2) NULL,
[DateOnFeeCalculated] [datetime] NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[FeeContributionBreakupId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFeeContributionBreakupAudit] ADD CONSTRAINT [PK_TFeeContributionBreakupAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
