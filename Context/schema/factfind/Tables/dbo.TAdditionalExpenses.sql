CREATE TABLE [dbo].[TAdditionalExpenses]
(
[AdditionalExpensesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[OpportunitySequentialRef] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AdditionalExpensesDescription] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ExpenseAmount] [decimal] (10, 2) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TAdditionalExpenses_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TAdditionalExpenses] ADD CONSTRAINT [PK_TAdditionalExpenses] PRIMARY KEY NONCLUSTERED  ([AdditionalExpensesId]) WITH (FILLFACTOR=80)
GO
