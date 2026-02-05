CREATE TABLE [dbo].[TFinancialPlanningGoalAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ObjectiveId] [int] NOT NULL,
[Objective] [varchar] (500) COLLATE Latin1_General_CI_AS NULL,
[TargetAmount] [money] NULL,
[StartDate] [datetime] NULL,
[TargetDate] [datetime] NULL,
[RiskProfileGuid] [uniqueidentifier] NULL,
[ObjectiveTypeId] [int] NULL,
[RefGoalCategoryId] [int] NULL,
[CRMContactId] [int] NULL,
[CRMContactId2] [int] NULL,
[FinancialPlanningSessionId] [int] NULL,
[RiskProfileId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningGoalAudit_ConcurrencyId] DEFAULT ((1)),
[FinancialPlanningGoalId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningGoalAudit] ADD CONSTRAINT [PK_TFinancialPlanningGoalAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
