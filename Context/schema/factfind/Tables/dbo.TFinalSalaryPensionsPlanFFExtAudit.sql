CREATE TABLE [dbo].[TFinalSalaryPensionsPlanFFExtAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[Employer] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL,
[FinalSalaryPensionsPlanFFExtId] [int] NOT NULL,
[StampAction] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NOT NULL,
[StampUser] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[TFinalSalaryPensionsPlanFFExtAudit] ADD CONSTRAINT [PK_TFinalSalaryPensionsPlanFFExtAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
