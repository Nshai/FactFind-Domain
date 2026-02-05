CREATE TABLE [dbo].[TKeyEmployeesToBeProtectedAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
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
[CRMContactId] [int] NOT NULL,
[KeyEmployeesToBeProtectedId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TKeyEmplo__Concu__3651FAE7] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TKeyEmployeesToBeProtectedAudit] ADD CONSTRAINT [PK_TKeyEmployeesToBeProtectedAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
