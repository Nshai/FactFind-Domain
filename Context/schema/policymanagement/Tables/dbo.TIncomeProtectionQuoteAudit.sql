CREATE TABLE [dbo].[TIncomeProtectionQuoteAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[QuoteId] [int] NOT NULL,
[ProductTermId] [int] NULL,
[QuotationBasisId] [int] NULL,
[QuotePremiumId] [int] NULL,
[IncludeRenewable] [bit] NOT NULL CONSTRAINT [DF_TIncomeProtectionQuoteAudit_IncludeRenewable] DEFAULT ((0)),
[MaximumAvailableBenefit] [bit] NOT NULL,
[DualDeferredPeriodsRequired] [bit] NOT NULL,
[IncludeLimitedPaymentPlans] [bit] NOT NULL,
[EmploymentStatus] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[InitialMonthlyBenefitId] [int] NULL,
[AdditionalMonthlyBenefitId] [int] NULL,
[BenefitIncreasingFrom] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[AnnualEarnedIncome] [decimal] (19, 2) NOT NULL,
[AnnualDividendIncome] [decimal] (19, 2) NOT NULL,
[ExistingBenefitAmount] [decimal] (19, 2) NULL,
[IncludeEmployerNIContributions] [bit] NOT NULL,
[IncludeEmployerPensionContributions] [bit] NOT NULL,
[MonthlyPensionContributions] [decimal] (19, 2) NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL,
[IncomeProtectionQuoteId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TIncomeProtectionQuoteAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TIncomeProtectionQuoteAudit] ADD CONSTRAINT [PK_TIncomeProtectionQuoteAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
