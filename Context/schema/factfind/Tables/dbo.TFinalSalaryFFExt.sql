CREATE TABLE [dbo].[TFinalSalaryFFExt]
(
[FinalSalaryFFExtId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[EmployerHasPensionSchemeFg] [bit] NULL,
[MemberOfEmployerPensionSchemeFg] [bit] NULL,
[EligibleToJoinEmployerPensionSchemeFg] [bit] NULL,
[DateEligibleToJoinEmployerPensionScheme] [datetime] NULL,
[WhyNotJoinedFg] [bit] NULL,
[HasExistingSchemesFg] [bit] NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
CREATE NONCLUSTERED INDEX [IDX_TFinalSalaryFFExt_CRMContactId] ON [dbo].[TFinalSalaryFFExt] ([CRMContactId]) WITH (FILLFACTOR=80)
GO
