CREATE TABLE [dbo].[TEmployeeBenefitAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Benefit] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Insurer] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[NumberOfEmployees] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[AnnualPremium] [money] NULL,
[LevelOfBenefits] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[EmployeeBenefitId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TEmployee__Concu__19B5BC39] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
