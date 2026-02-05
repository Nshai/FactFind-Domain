CREATE TABLE [dbo].[TPreExistingFinalSalaryPensionPlansQuestionsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[EmployerHasPensionSchemeFg] [bit] NULL,
[MemberOfEmployerPensionSchemeFg] [bit] NULL,
[EligibleToJoinEmployerPensionSchemeFg] [bit] NULL,
[DateEligibleToJoinEmployerPensionScheme] [datetime] NULL,
[WhyNotJoinedFg] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[HasExistingSchemesFg] [bit] NULL,
[CRMContactId] [int] NOT NULL,
[PreExistingFinalSalaryPensionPlansQuestionsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TPreExist__Concu__7AFC2AEF] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPreExistingFinalSalaryPensionPlansQuestionsAudit] ADD CONSTRAINT [PK_TPreExistingFinalSalaryPensionPlansQuestionsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
