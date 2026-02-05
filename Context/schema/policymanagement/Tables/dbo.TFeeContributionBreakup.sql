CREATE TABLE [dbo].[TFeeContributionBreakup]
(
[FeeContributionBreakupId] [int] NOT NULL IDENTITY(1, 1),
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
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFeeContributionBreakup_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFeeContributionBreakup] ADD CONSTRAINT [PK_TFeeContributionBreakup] PRIMARY KEY CLUSTERED  ([FeeContributionBreakupId])
GO
ALTER TABLE [dbo].[TFeeContributionBreakup] ADD CONSTRAINT [FK_TFeeContributionBreakup_TFee] FOREIGN KEY ([FeeId]) REFERENCES [dbo].[TFee] ([FeeId])
GO
ALTER TABLE [dbo].[TFeeContributionBreakup] ADD CONSTRAINT [FK_TFeeContributionBreakup_TPolicyBusiness] FOREIGN KEY ([PolicyBusinessId]) REFERENCES [dbo].[TPolicyBusiness] ([PolicyBusinessId])
GO
