CREATE TABLE [dbo].[TFullQuoteIncomeDetails]
(
[FullQuoteIncomeDetailsId] [int] NOT NULL IDENTITY(1, 1),
[FullQuoteId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[EmploymentType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[EmploymentTypeOther] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[TimeAtEmployer] [int] NULL,
[BasicGrossSalary] [decimal] (10, 2) NULL,
[Overtime] [decimal] (10, 2) NULL,
[Bonus] [decimal] (10, 2) NULL,
[Commission] [decimal] (10, 2) NULL,
[OtherIncome] [decimal] (10, 2) NULL,
[SelfEmployedType] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[SelfEmployedIncome] [decimal] (10, 2) NULL,
[Year1] [decimal] (10, 2) NULL,
[Year2] [decimal] (10, 2) NULL,
[Year3] [decimal] (10, 2) NULL,
[SelfCertification] [bit] NULL,
[FullStatus] [bit] NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TFullQuoteIncomeDetails] ADD CONSTRAINT [PK_TFullQuoteIncomeDetails] PRIMARY KEY NONCLUSTERED  ([FullQuoteIncomeDetailsId])
GO
