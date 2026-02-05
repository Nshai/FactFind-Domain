CREATE TABLE [dbo].[TGroupSchemeAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
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
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TGroupSchemeAudit_ConcurrencyId] DEFAULT ((1)),
[GroupSchemeId] [int] NOT NULL,
[StampAction] [char] (1) NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TGroupSchemeAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) NULL,
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
ALTER TABLE [dbo].[TGroupSchemeAudit] ADD CONSTRAINT [PK_TGroupSchemeAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TGroupSchemeAudit_GroupSchemeId_ConcurrencyId] ON [dbo].[TGroupSchemeAudit] ([GroupSchemeId], [ConcurrencyId])
GO
