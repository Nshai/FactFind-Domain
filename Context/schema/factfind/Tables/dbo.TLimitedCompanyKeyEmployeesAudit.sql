CREATE TABLE [dbo].[TLimitedCompanyKeyEmployeesAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[RolesDuties] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[DOB] [datetime] NULL,
[Smoker] [bit] NULL,
[GoodHealth] [bit] NULL,
[CRMContactId] [int] NOT NULL,
[LimitedCompanyKeyEmployeesId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLimitedCompanyKeyEmployeesAudit_ConcurrencyId] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TLimitedCompanyKeyEmployeesAudit] ADD CONSTRAINT [PK_TLimitedCompanyKeyEmployeesAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
