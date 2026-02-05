CREATE TABLE [dbo].[TEmployeeCategories]
(
[EmployeeCategoriesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Category] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Number] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[DetailsOfDuties] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[NormalRetirement] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[WorkingHours] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[RegularOvertime] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[AverageWeeklyEarnings] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TEmployee__Concu__44160A59] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TEmployeeCategories_CRMContactId] ON [dbo].[TEmployeeCategories] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
