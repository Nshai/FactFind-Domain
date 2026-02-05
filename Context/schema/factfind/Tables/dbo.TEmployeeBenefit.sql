CREATE TABLE [dbo].[TEmployeeBenefit]
(
[EmployeeBenefitId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Benefit] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Insurer] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[NumberOfEmployees] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[AnnualPremium] [money] NULL,
[LevelOfBenefits] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TEmployee__Concu__45FE52CB] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TEmployeeBenefit_CRMContactId] ON [dbo].[TEmployeeBenefit] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
