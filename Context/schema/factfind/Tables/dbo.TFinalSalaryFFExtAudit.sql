CREATE TABLE [dbo].[TFinalSalaryFFExtAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[EmployerHasPensionSchemeFg] [bit] NULL,
[MemberOfEmployerPensionSchemeFg] [bit] NULL,
[EligibleToJoinEmployerPensionSchemeFg] [bit] NULL,
[DateEligibleToJoinEmployerPensionScheme] [datetime] NULL,
[WhyNotJoinedFg] [bit] NULL,
[HasExistingSchemesFg] [bit] NULL,
[ConcurrencyId] [int] NOT NULL,
[FinalSalaryFFExtId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinalSalaryFFExtAudit] ADD CONSTRAINT [PK_TFinalSalaryFFExtAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
