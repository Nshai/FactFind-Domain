CREATE TABLE [dbo].[TRetirementNextSteps]
(
[RetirementNextStepsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[NextSteps] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TRetireme__Concu__3E2826D9] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TRetirementNextSteps_CRMContactId] ON [dbo].[TRetirementNextSteps] ([CRMContactId])
GO
