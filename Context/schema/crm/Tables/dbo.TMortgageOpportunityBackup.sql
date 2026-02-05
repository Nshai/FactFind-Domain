CREATE TABLE [dbo].[TMortgageOpportunityBackup]
(
[MortgageOpportunityId] [int] NOT NULL IDENTITY(1, 1),
[OpportunityId] [int] NOT NULL,
[LoanPurpose] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[LoanAmount] [decimal] (10, 2) NULL,
[LTV] [decimal] (10, 2) NULL,
[RefMortgageBorrowerTypeId] [int] NULL,
[Term] [int] NULL,
[RefMortgageRepaymentMethodId] [int] NULL,
[InterestOnly] [decimal] (10, 2) NULL,
[Repayment] [decimal] (10, 2) NULL,
[Price] [decimal] (10, 2) NULL,
[Deposit] [decimal] (10, 2) NULL,
[PlanPurpose] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[CurrentLender] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[CurrentLoanAmount] [decimal] (10, 2) NULL,
[MonthlyRentalIncome] [decimal] (10, 2) NULL,
[EquityLoanPercentage] [decimal] (5,2) NULL,
[EquityLoanAmount] [money] NULL,
[StatusFg] [bit] NULL CONSTRAINT [DF_TMortgageOpportunityBackup_StatusFg] DEFAULT ((0)),
[SelfCertFg] [bit] NULL CONSTRAINT [DF_TMortgageOpportunityBackup_SelfCertFg] DEFAULT ((0)),
[NonStatusFg] [bit] NULL CONSTRAINT [DF_TMortgageOpportunityBackup_NonStatusFg] DEFAULT ((0)),
[ExPatFg] [bit] NULL CONSTRAINT [DF_TMortgageOpportunityBackup_ExPatFg] DEFAULT ((0)),
[ForeignCitizenFg] [bit] NULL CONSTRAINT [DF_TMortgageOpportunityBackup_ForeignCitizenFg] DEFAULT ((0)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMortgageOpportunityBackup_ConcurrencyId] DEFAULT ((1))
)
GO
