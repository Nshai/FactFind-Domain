CREATE TABLE [dbo].[TContributionsDetails]
(
[ContributionsDetailsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[EmployerPercentage] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[EmployeePercentage] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[EmployerFixedCost] [money] NULL,
[EmployeeFixedCost] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TContribu__Concu__7B663F43] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TContributionsDetails_CRMContactId] ON [dbo].[TContributionsDetails] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
