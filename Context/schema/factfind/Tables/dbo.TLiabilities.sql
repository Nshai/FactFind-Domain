CREATE TABLE [dbo].[TLiabilities]
(
[LiabilitiesId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId] [int] NOT NULL,
[CRMContactId2] [int] NULL,
[Owner] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[CommitedOutgoings] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[description] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[repayorinterest] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[LoanCategory] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Amount] [money] NULL,
[LenderName] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[OriginalTerm] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[LoanAmount] [money] NULL,
[LoanType] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[Repayments] [money] NULL,
[RepaymentFrequency] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Protected] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[InterestRate] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[RateType] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ProtectedYesNo] [bit] NULL,
[PolicyBusinessId] [int] NULL,
[IsSecure] [bit] NULL,
[IsMortgage] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLiabilities_ConcurrencyId] DEFAULT ((1)),
[EarlyRedemptionCharge] [money] NULL,
[IsConsolidated] [bit] NULL,
[IsToBeRepaid] [bit] NULL,
[HowWillItBeRepaid] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[PaymentAmountPerMonth] [money] NULL,
[CreditLimit] [money] NULL,
[TotalLoanAmount] [money] NULL,
[LiabilityAccountNumber] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsGuarantorMortgage] [bit] NULL,
[LiabilityMigrationRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[InterestRateType] [varchar] (32) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TLiabilities] ADD CONSTRAINT [PK_TLiabilities] PRIMARY KEY CLUSTERED  ([LiabilitiesId])
GO
CREATE NONCLUSTERED INDEX [IDX_TLiabilities_CRMContactId] ON [dbo].[TLiabilities] ([CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IDX_TLiabilities_CRMContactId2] ON [dbo].[TLiabilities] ([CRMContactId2])
GO
