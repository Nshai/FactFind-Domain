CREATE TABLE [dbo].[TMortgageQuoteSummary]
(
[MortgageQuoteSummaryId] [int] NOT NULL IDENTITY(1, 1),
[ProductName] [nvarchar] (512) COLLATE Latin1_General_CI_AS NULL,
[RefApplicationId] [int] NULL,
[ApplicationTypeId] [int] NULL,
[PropertyValue] [money] NULL,
[LoanAmount] [money] NULL,
[Deposit] [money] NULL,
[LTV] [float] NULL,
[Term] [int] NULL,
[TrueCostTerm] [int] NULL,
[QuoteId] [int] NOT NULL,
[MortgageQuoteId] [int] NOT NULL,
[KFIDocVersionId] [int] NULL,
[ProductFeatures] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[SortedBy] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMortgageQuoteSummary_ConcurrencyId] DEFAULT ((1)),
[RefMortgageRepaymentMethodId] [int] NULL,
[RefMortgageBorrowerTypeId] [int] NULL,
[ProcFee] [money] NULL,
[MortgageRefNo] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[RateType] [nvarchar] (50) COLLATE Latin1_General_CI_AS NULL,
[RedemptionTerms] [nvarchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[RedemptionCharge] [float] NULL,
[IsPortable] [bit] NULL,
[TieInEndDate] [datetime] NULL,
[LenderFees] [money] NULL,
[FeesAddedToLoan] [bit] NULL,
[SelectedLenderName] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[IsSplitRepayment] [bit] NULL,
[InterestOnlyLoanAmount] [money] NULL,
[MteFormCode] [nvarchar] (25) COLLATE Latin1_General_CI_AS NULL,
[CanApplyViaMte] [bit] NULL,
[PolicyBusinessId] [int] NULL,
[InterestOnlyTerm] [int] NULL,
[IsFirstTimeBuyer] [bit] NULL
)
GO
ALTER TABLE [dbo].[TMortgageQuoteSummary] ADD CONSTRAINT [PK_TMortgageQuoteSummary] PRIMARY KEY CLUSTERED  ([MortgageQuoteSummaryId])
GO
CREATE NONCLUSTERED INDEX IX_TMortgageQuoteSummary_PolicyBusinessId ON [dbo].[TMortgageQuoteSummary] ([PolicyBusinessId]) INCLUDE ([MortgageQuoteSummaryId],[QuoteId])
GO