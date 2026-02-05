CREATE TABLE [dbo].[TEmployeeInformationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[NumOfFTEmp] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[NumOfPTEmp] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[NumOfEmpBelow20] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[NumOfEmp20_29] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[NumOfEmp30_39] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[NumOfEmp40_49] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[NumOfEmp50_59] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[NumOfEmp60_over] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[EmployeeInformationId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TEmployee__Concu__15E52B55] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
