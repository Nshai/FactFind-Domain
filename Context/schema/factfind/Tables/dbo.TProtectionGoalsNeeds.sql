CREATE TABLE [dbo].[TProtectionGoalsNeeds]
(
[ProtectionGoalsNeedsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[GoalsAndNeeds] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TProtecti__Concu__349EBC9F] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TProtectionGoalsNeeds_CRMContactId] ON [dbo].[TProtectionGoalsNeeds] ([CRMContactId])
GO
