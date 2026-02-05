CREATE TABLE [dbo].[TEmployeeCategoriesAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Category] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Number] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[DetailsOfDuties] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[NormalRetirement] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[WorkingHours] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[RegularOvertime] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[AverageWeeklyEarnings] [money] NULL,
[CRMContactId] [int] NOT NULL,
[EmployeeCategoriesId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TEmployee__Concu__17CD73C7] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
