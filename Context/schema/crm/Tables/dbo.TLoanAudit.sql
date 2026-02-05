CREATE TABLE [dbo].[TLoanAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CrmContactId] [int] NOT NULL,
[Joint] [bit] NULL,
[Type] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Balance] [money] NULL,
[Purpose] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[StartDate] [datetime] NULL,
[OriginalTerm] [int] NULL,
[MonthlyPayments] [money] NULL,
[Death] [bit] NULL,
[Sickness] [bit] NULL,
[Unemployment] [bit] NULL,
[ConcurrencyId] [int] NOT NULL,
[LoanId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TLoanAudit] ADD CONSTRAINT [PK_TLoanAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
