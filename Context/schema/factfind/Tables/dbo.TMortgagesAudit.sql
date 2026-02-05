CREATE TABLE [dbo].[TMortgagesAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
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
[CRMContactId] [int] NOT NULL,
[MortgagesId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TMortgage__Concu__4D6A6A69] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TMortgagesAudit] ADD CONSTRAINT [PK_TMortgagesAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
