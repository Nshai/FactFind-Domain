CREATE TABLE [dbo].[TEstateNextSteps]
(
[EstateNextStepsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[NextSteps] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TEstateNe__Concu__45C948A1] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TEstateNextSteps_CRMContactId] ON [dbo].[TEstateNextSteps] ([CRMContactId])
GO
