CREATE TABLE [dbo].[TEstateGoalsNeeds]
(
[EstateGoalsNeedsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[GoalsAndNeeds] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TEstateGo__Concu__43E1002F] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TEstateGoalsNeeds_CRMContactId] ON [dbo].[TEstateGoalsNeeds] ([CRMContactId])
GO
