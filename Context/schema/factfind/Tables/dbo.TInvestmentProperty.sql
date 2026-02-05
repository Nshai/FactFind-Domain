CREATE TABLE [dbo].[TInvestmentProperty]
(
[InvestmentPropertyId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Description] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Type] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Owner] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[PurchasedOn] [datetime] NULL,
[PurchasePrice] [money] NULL,
[Amount] [money] NULL,
[LoanAmount] [money] NULL,
[InterestRate] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[OriginalTerm] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[LoanType] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Repayments] [money] NULL,
[RentalIncome] [money] NULL,
[ExpensesRates] [money] NULL,
[Maintenance] [money] NULL,
[AgentFees] [money] NULL,
[Insurance] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TInvestme__Concu__1FD8A9E3] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TInvestmentProperty_CRMContactId] ON [dbo].[TInvestmentProperty] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
