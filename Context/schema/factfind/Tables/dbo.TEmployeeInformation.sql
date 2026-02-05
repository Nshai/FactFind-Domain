CREATE TABLE [dbo].[TEmployeeInformation]
(
[EmployeeInformationId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[NumOfFTEmp] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[NumOfPTEmp] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[NumOfEmpBelow20] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[NumOfEmp20_29] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[NumOfEmp30_39] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[NumOfEmp40_49] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[NumOfEmp50_59] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[NumOfEmp60_over] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TEmployee__Concu__422DC1E7] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TEmployeeInformation_CRMContactId] ON [dbo].[TEmployeeInformation] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
