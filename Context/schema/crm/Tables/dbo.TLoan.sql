CREATE TABLE [dbo].[TLoan]
(
[LoanId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
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
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TLoan] ADD CONSTRAINT [PK_TLoan] PRIMARY KEY CLUSTERED  ([LoanId]) WITH (FILLFACTOR=80)
GO
