CREATE TABLE [dbo].[TPensionContributions]
(
[PensionContributionsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[EmployerPercentage] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[EmployeePercentage] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[EmployerFixedCost] [money] NULL,
[EmployeeFixedCost] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPensionC__Concu__3A8CA01F] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TPensionContributions_CRMContactId] ON [dbo].[TPensionContributions] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
