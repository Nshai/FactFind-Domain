CREATE TABLE [dbo].[TInvestmentPropertyAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
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
[CRMContactId] [int] NOT NULL,
[InvestmentPropertyId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TInvestme__Concu__73901351] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TInvestmentPropertyAudit] ADD CONSTRAINT [PK_TInvestmentPropertyAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
