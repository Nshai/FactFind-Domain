CREATE TABLE [dbo].[TRetirementGoalsNeeds]
(
[RetirementGoalsNeedsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[GoalsAndNeeds] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TRetireme__Concu__3A5795F5] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TRetirementGoalsNeeds_CRMContactId] ON [dbo].[TRetirementGoalsNeeds] ([CRMContactId])
GO
