CREATE TABLE [dbo].[TFinalSalaryPensionsPlanFFExt]
(
[FinalSalaryPensionsPlanFFExtId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[Employer] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
CREATE NONCLUSTERED INDEX [IX_INCL_TFinalSalaryPensionsPlanFFExt_PolicyBusinessId] ON [dbo].[TFinalSalaryPensionsPlanFFExt] ([PolicyBusinessId]) INCLUDE ([Employer])
GO
