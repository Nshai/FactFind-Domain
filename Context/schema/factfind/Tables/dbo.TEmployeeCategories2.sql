CREATE TABLE [dbo].[TEmployeeCategories2]
(
[EmployeeCategories2Id] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[ComputerisedPayroll] [bit] NULL,
[TotalSalaryRoll] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[StaffingLevelsIncreasing] [bit] NULL,
[Reviewdate] [datetime] NULL,
[EmployeesAffiliatedToTradeUnion] [bit] NULL,
[TradeUnionAgreementNeeded] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TEmployee__Concu__47E69B3D] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TEmployeeCategories2_CRMContactId] ON [dbo].[TEmployeeCategories2] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
