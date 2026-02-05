CREATE TABLE [dbo].[TLimitedCompanyKeyEmployees]
(
[LimitedCompanyKeyEmployeesId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Name] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[RolesDuties] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[DOB] [datetime] NULL,
[Smoker] [bit] NULL,
[GoodHealth] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TLimitedCompanyKeyEmployees_ConcurrencyId] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TLimitedCompanyKeyEmployees_CRMContactId] ON [dbo].[TLimitedCompanyKeyEmployees] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
