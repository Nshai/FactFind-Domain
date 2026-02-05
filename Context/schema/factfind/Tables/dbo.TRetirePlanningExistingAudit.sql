CREATE TABLE [dbo].[TRetirePlanningExistingAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[RetirementPlanningObjectives] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[CurrentPensionArrangements] [bit] NULL,
[PlanTypes] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[RetirePlanningExistingId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TRetirePl__Concu__2AE0483B] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRetirePlanningExistingAudit] ADD CONSTRAINT [PK_TRetirePlanningExistingAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
