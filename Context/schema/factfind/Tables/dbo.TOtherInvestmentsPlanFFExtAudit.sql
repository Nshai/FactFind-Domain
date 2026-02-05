CREATE TABLE [dbo].[TOtherInvestmentsPlanFFExtAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[ContributionThisTaxYearFg] [bit] NULL,
[MonthlyIncome] [money] NULL,
[InTrustFg] [bit] NULL,
[ConcurrencyId] [int] NOT NULL,
[OtherInvestmentsPlanFFExtId] [int] NOT NULL,
[StampAction] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NOT NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[TOtherInvestmentsPlanFFExtAudit] ADD CONSTRAINT [PK_TOtherInvestmentsPlanFFExtAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
