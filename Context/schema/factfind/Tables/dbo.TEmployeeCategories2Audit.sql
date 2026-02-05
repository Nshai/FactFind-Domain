CREATE TABLE [dbo].[TEmployeeCategories2Audit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ComputerisedPayroll] [bit] NULL,
[TotalSalaryRoll] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[StaffingLevelsIncreasing] [bit] NULL,
[Reviewdate] [datetime] NULL,
[EmployeesAffiliatedToTradeUnion] [bit] NULL,
[TradeUnionAgreementNeeded] [bit] NULL,
[CRMContactId] [int] NOT NULL,
[EmployeeCategories2Id] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TEmployee__Concu__1B9E04AB] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
