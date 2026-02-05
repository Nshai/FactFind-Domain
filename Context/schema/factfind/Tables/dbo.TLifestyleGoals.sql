CREATE TABLE [dbo].[TLifestyleGoals]
(
[LifestyleGoalsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Description] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Owner] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Amount] [money] NULL,
[Frequency] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[StartDate] [datetime] NULL,
[Finishing] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[AnnualIncrease] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TLifestyl__Concu__1A1FD08D] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TLifestyleGoals_CRMContactId] ON [dbo].[TLifestyleGoals] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
