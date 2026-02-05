CREATE TABLE [dbo].[TSpecialProjects]
(
[SpecialProjectsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[SpecialProjectsYesNo] [bit] NULL,
[FuturePlans] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[Notes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TSpecialProjects__ConcurrencyId] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TSpecialProjects_CRMContactId] ON [dbo].[TSpecialProjects] ([CRMContactId])
GO
