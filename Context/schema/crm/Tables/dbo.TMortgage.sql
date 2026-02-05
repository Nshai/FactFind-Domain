CREATE TABLE [dbo].[TMortgage]
(
[MortgageId] [int] NOT NULL IDENTITY(1, 1),
[Applicant] [int] NOT NULL,
[Joint] [bit] NULL,
[FirstTimeBuyer] [bit] NOT NULL CONSTRAINT [DF_TMortgage_FirstTimeBuyer] DEFAULT ((0)),
[HomeMover] [bit] NOT NULL CONSTRAINT [DF_TMortgage_HomeMover] DEFAULT ((0)),
[InvestmentProperty] [bit] NOT NULL CONSTRAINT [DF_TMortgage_InvestmentProperty] DEFAULT ((0)),
[Remortgage] [bit] NOT NULL CONSTRAINT [DF_TMortgage_Remortgage] DEFAULT ((0)),
[FurtherAdvance] [bit] NOT NULL CONSTRAINT [DF_TMortgage_FurtherAdvance] DEFAULT ((0)),
[SecondHome] [bit] NOT NULL CONSTRAINT [DF_TMortgage_SecondHome] DEFAULT ((0)),
[Refinancing] [bit] NOT NULL CONSTRAINT [DF_TMortgage_Refinancing] DEFAULT ((0)),
[Other] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Amount] [money] NOT NULL CONSTRAINT [DF_TMortgage_Amount] DEFAULT ((0.00)),
[Term] [int] NULL,
[TypeRequired] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[UpperLimitMortgageCost] [bit] NOT NULL CONSTRAINT [DF_TMortgage_UpperLimitMortgageCost] DEFAULT ((0)),
[FixedPeriodRequired] [bit] NOT NULL CONSTRAINT [DF_TMortgage_FixedPeriodRequired] DEFAULT ((0)),
[Cashback] [bit] NOT NULL CONSTRAINT [DF_TMortgage_Cashback] DEFAULT ((0)),
[DiscountedRate] [bit] NOT NULL CONSTRAINT [DF_TMortgage_DiscountedRate] DEFAULT ((0)),
[SettlementCosts] [bit] NOT NULL CONSTRAINT [DF_TMortgage_SettlementCosts] DEFAULT ((0)),
[NoTieIn] [bit] NOT NULL CONSTRAINT [DF_TMortgage_NoTieIn] DEFAULT ((0)),
[NoHighLendingFee] [bit] NOT NULL CONSTRAINT [DF_TMortgage_NoHighLendingFee] DEFAULT ((0)),
[AddFeeOrLoan] [bit] NOT NULL CONSTRAINT [DF_TMortgage_AddFeeOrLoan] DEFAULT ((0)),
[VariablePayments] [bit] NOT NULL CONSTRAINT [DF_TMortgage_VariablePayments] DEFAULT ((0)),
[IndependantQuotes] [bit] NOT NULL CONSTRAINT [DF_TMortgage_IndependantQuotes] DEFAULT ((0)),
[Address] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[PropertyValue] [money] NOT NULL CONSTRAINT [DF_TMortgage_PropertyValue] DEFAULT ((0.00)),
[Tenancy] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[LeaseYears] [int] NULL,
[PropertyType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[CurrentAddressTime] [int] NULL,
[OtherAddressDetails] [varchar] (1000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMortgage_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TMortgage] ADD CONSTRAINT [PK_TMortgage] PRIMARY KEY CLUSTERED  ([MortgageId]) WITH (FILLFACTOR=80)
GO
