CREATE TABLE [dbo].[TAdditionalExpensesAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[OpportunitySequentialRef] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AdditionalExpensesDescription] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ExpenseAmount] [decimal] (10, 2) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdditionalExpensesAudit_ConcurrencyId] DEFAULT ((1)),
[AdditionalExpensesId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAdditionalExpensesAudit] ADD CONSTRAINT [PK_TAdditionalExpensesAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
