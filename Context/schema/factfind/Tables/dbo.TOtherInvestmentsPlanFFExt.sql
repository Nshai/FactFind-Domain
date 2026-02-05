CREATE TABLE [dbo].[TOtherInvestmentsPlanFFExt]
(
[OtherInvestmentsPlanFFExtId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[ContributionThisTaxYearFg] [bit] NULL,
[MonthlyIncome] [money] NULL,
[InTrustFg] [bit] NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
CREATE NONCLUSTERED INDEX IX_TOtherInvestmentsPlanFFExt_PolicyBusinessID ON [dbo].[TOtherInvestmentsPlanFFExt] ([PolicyBusinessId]) INCLUDE ([ContributionThisTaxYearFg],[MonthlyIncome]) 
GO