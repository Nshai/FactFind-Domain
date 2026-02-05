CREATE TABLE [dbo].[TFullQuoteIncomeDetailsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
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
[ConcurrencyId] [nchar] (20) COLLATE Latin1_General_CI_AS NULL,
[FullQuoteIncomeDetailsId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFullQuoteIncomeDetailsAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFullQuoteIncomeDetailsAudit] ADD CONSTRAINT [PK_TFullQuoteIncomeDetailsAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFullQuoteIncomeDetailsAudit_FullQuoteIncomeDetailsId_ConcurrencyId] ON [dbo].[TFullQuoteIncomeDetailsAudit] ([FullQuoteIncomeDetailsId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
