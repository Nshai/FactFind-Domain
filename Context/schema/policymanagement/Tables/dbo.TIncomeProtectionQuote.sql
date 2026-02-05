CREATE TABLE [dbo].[TIncomeProtectionQuote]
(
[IncomeProtectionQuoteId] [int] NOT NULL IDENTITY(1, 1),
[QuoteId] [int] NOT NULL,
[ProductTermId] [int] NULL,
[QuotationBasisId] [int] NULL,
[MaximumAvailableBenefit] [bit] NOT NULL CONSTRAINT [DF_TQuotationBasis_MaximumAvailableBenefit] DEFAULT ((0)),
[QuotePremiumId] [int] NULL,
[IncludeRenewable] [bit] NOT NULL CONSTRAINT [DF_TIncomeProtectionQuote_IncludeRenewable] DEFAULT ((0)),
[DualDeferredPeriodsRequired] [bit] NOT NULL CONSTRAINT [DF_IncomeProtectionQuote_DualDeferredPeriodsRequired] DEFAULT ((0)),
[IncludeLimitedPaymentPlans] [bit] NOT NULL CONSTRAINT [DF_IncomeProtectionQuote_IncludeLimitedPaymentPlans] DEFAULT ((0)),
[EmploymentStatus] [nvarchar] (255)  NOT NULL,
[InitialMonthlyBenefitId] [int] NULL,
[AdditionalMonthlyBenefitId] [int] NULL,
[BenefitIncreasingFrom] [nvarchar] (255)  NULL,
[AnnualEarnedIncome] [decimal] (19, 2) NOT NULL,
[AnnualDividendIncome] [decimal] (19, 2) NOT NULL CONSTRAINT [DF_TIncomeProtectionQuote_AnnualDividendIncome] DEFAULT ((0.00)),
[ExistingBenefitAmount] [decimal] (19, 2) NULL,
[IncludeEmployerNIContributions] [bit] NOT NULL CONSTRAINT [DF_TIncomeProtectionQuote_IncludeEmployerNIContributions] DEFAULT ((0)),
[IncludeEmployerPensionContributions] [bit] NOT NULL CONSTRAINT [DF_TIncomeProtectionQuote_IncludeEmployerPensionContributions] DEFAULT ((0)),
[MonthlyPensionContributions] [decimal] (19, 2) NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TIncomeProtectionQuote_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TIncomeProtectionQuote] ADD CONSTRAINT [PK_TIncomeProtectionQuote] PRIMARY KEY CLUSTERED  ([IncomeProtectionQuoteId])
GO
CREATE NONCLUSTERED INDEX [IX_TIncomeProtectionQuote_QuoteId] ON [dbo].[TIncomeProtectionQuote] ([QuoteId])
GO
ALTER TABLE [dbo].[TIncomeProtectionQuote] WITH CHECK ADD CONSTRAINT [FK_TIncomeProtectionQuote_TQuote] FOREIGN KEY ([QuoteId]) REFERENCES [dbo].[TQuote] ([QuoteId])
GO
