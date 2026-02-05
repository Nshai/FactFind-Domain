CREATE TABLE [dbo].[TSavingsNextSteps]
(
[SavingsNextStepsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[NextSteps] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TSavingsN__Concu__41F8B7BD] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TSavingsNextSteps_CRMContactId] ON [dbo].[TSavingsNextSteps] ([CRMContactId])
GO
