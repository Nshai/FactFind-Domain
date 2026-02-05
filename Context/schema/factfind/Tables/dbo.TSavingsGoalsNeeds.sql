CREATE TABLE [dbo].[TSavingsGoalsNeeds]
(
[SavingsGoalsNeedsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[GoalsAndNeeds] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TSavingsG__Concu__40106F4B] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TSavingsGoalsNeeds_CRMContactId] ON [dbo].[TSavingsGoalsNeeds] ([CRMContactId])
GO
