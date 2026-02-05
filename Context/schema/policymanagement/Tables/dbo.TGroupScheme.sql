CREATE TABLE [dbo].[TGroupScheme]
(
[GroupSchemeId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[OwnerCRMContactId] [int] NOT NULL,
[SchemeTypeId] [int] NOT NULL,
[SchemeNumber] [varchar] (50) NULL,
[SchemeName] [varchar] (50) NULL,
[RenewalDate] [datetime] NULL,
[PaymentMethod] [int] NULL,
[ExpectedPaymentDate] [int] NULL,
[ContributionAmount] [money] NULL,
[AnnualMgmtCharge] [varchar] (255) NULL,
[TermsAgreedDate] [datetime] NULL,
[EventListid] [int] NULL,
[PremiumFrequency] [int] NULL,
[SchemeCommissionRate] [decimal] (10, 2) NULL,
[SchemeCommissionTypeId] [int] NULL,
[IsCalculateCommissionDue] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TGroupScheme_ConcurrencyId] DEFAULT ((1)),
[NonActiveMemberAmcPercentage] [varchar] (255) NULL,
[DefaultFund] [varchar] (50) NULL,
[SEEmployerReviewDate] [datetime] NULL,
[RefSalaryExchangeTypeId] [int] NULL,
[StagingDate] [datetime] NULL,
[TriAnnualDate] [datetime] NULL,
[CertificateExpiryDate] [datetime] NULL,
[PayrollCutOffDay] [int] NULL,
[PostponementInformation] [varchar] (255) NULL,
[DefaultFundUnitId] [int] NULL,
[DefaultNonFeedFundId] [int] NULL,
[PensionSchemeTaxReference] [varchar] (100) NULL,
[LumpSumAnnualMgmtCharge] [varchar] (255) NULL,
[TransferAnnualMgmtCharge] [varchar] (255) NULL,
[RefRegisteredId] [int] NULL, 
[IsCopyOfTrustHeld] [bit] NULL,
[IsPrincipalEmployerATrustee] [bit] NULL
)
GO
ALTER TABLE [dbo].[TGroupScheme] ADD CONSTRAINT [PK_TGroupScheme] PRIMARY KEY CLUSTERED  ([GroupSchemeId])
GO
CREATE NONCLUSTERED INDEX [IX_TGroupScheme_PolicyBusinessId] ON [dbo].[TGroupScheme] ([PolicyBusinessId])
GO
ALTER TABLE [dbo].[TGroupScheme] ADD CONSTRAINT [FK_TGroupScheme_PolicyBusinessId_TPolicyBusiness] FOREIGN KEY ([PolicyBusinessId]) REFERENCES [dbo].[TPolicyBusiness] ([PolicyBusinessId])
GO
ALTER TABLE [dbo].[TGroupScheme] ADD CONSTRAINT [FK_TGroupScheme_TRefSalaryExchangeType] FOREIGN KEY ([RefSalaryExchangeTypeId]) REFERENCES [dbo].[TRefSalaryExchangeType] ([RefSalaryExchangeTypeId])
GO
CREATE NONCLUSTERED INDEX [IX_TGroupScheme_TenantId_OwnerCRMContactId] ON [dbo].[TGroupScheme] ([TenantId],[OwnerCRMContactId])
GO

