CREATE TABLE [dbo].[TPreExistingFinalSalaryPensionPlansQuestions]
(
[PreExistingFinalSalaryPensionPlansQuestionsId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[EmployerHasPensionSchemeFg] [bit] NULL,
[MemberOfEmployerPensionSchemeFg] [bit] NULL,
[EligibleToJoinEmployerPensionSchemeFg] [bit] NULL,
[DateEligibleToJoinEmployerPensionScheme] [datetime] NULL,
[WhyNotJoinedFg] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[HasExistingSchemesFg] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPreExist__Concu__2744C181] DEFAULT ((1))
)
GO
CREATE NONCLUSTERED INDEX [IDX_TPreExistingFinalSalaryPensionPlansQuestions_CRMContactId] ON [dbo].[TPreExistingFinalSalaryPensionPlansQuestions] ([CRMContactId])
GO
