CREATE TABLE [dbo].[TMortgages]
(
[MortgagesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Lender] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[LoanAmount] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[StartDate] [datetime] NULL,
[OriginalTerm] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Balance] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[LoanType] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[MonthlyPayments] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[InterestRate] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Death] [bit] NULL,
[Sickness] [bit] NULL,
[Unemployment] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TMortgage__Concu__79B300FB] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TMortgages_CRMContactId] ON [dbo].[TMortgages] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
