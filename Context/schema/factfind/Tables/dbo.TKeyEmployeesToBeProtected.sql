CREATE TABLE [dbo].[TKeyEmployeesToBeProtected]
(
[KeyEmployeesToBeProtectedId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[ShareHolderName] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[ShareHolderRole] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[DOB] [datetime] NULL,
[SmokerYesNo] [bit] NULL,
[SuccessorYesNo] [bit] NULL,
[DateJoinedCompany] [datetime] NULL,
[CurrentValue] [money] NULL,
[PercentageInterest] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[CurrentYear] [money] NULL,
[LastYear] [money] NULL,
[TwoYearsAgo] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TKeyEmplo__Concu__629A9179] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TKeyEmployeesToBeProtected_CRMContactId] ON [dbo].[TKeyEmployeesToBeProtected] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
