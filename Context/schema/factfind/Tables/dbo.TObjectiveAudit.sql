CREATE TABLE [dbo].[TObjectiveAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Objective] [varchar] (500) COLLATE Latin1_General_CI_AS NULL,
[TargetAmount] [money] NULL,
[StartDate] [datetime] NULL,
[TargetDate] [datetime] NULL,
[RegularImmediateIncome] [bit] NULL,
[ReasonForChange] [varchar] (200) COLLATE Latin1_General_CI_AS NULL,
[RiskProfileGuid] [uniqueidentifier] NULL,
[CRMContactId] [int] NULL,
[ObjectiveTypeId] [int] NOT NULL,
[IsFactFind] [bit] NOT NULL,
[Details] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[Frequency] [int] NULL,
[RetirementAge] [int] NULL,
[LumpSumAtRetirement] [money] NULL,
[AnnualPensionIncome] [money] NULL,
[ConcurrencyId] [int] NOT NULL,
[ObjectiveId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TObjectiveAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId2] [int] NULL,
[GoalType] [tinyint] NULL,
[RiskDiscrepency] [int] NULL,
[RiskProfileAdjustedDate] [datetime] NULL,
[RefLumpsumAtRetirementTypeId] [int] NULL,
[RefGoalCategoryId] [int] NULL,
[RefIncreaseRateId] [int] NULL,
[MarkedAsCompletedDate] [datetime] NULL,
[AccountId] [int] NULL,
[PlanId] [int] NULL,
[IsCreatedByClient] [bit] NULL,
[MarkedAsCompletedByUserId] [int] NULL,
[IsAtRetirement] [bit] NULL,
[TermInYears] [tinyint] NULL
)
GO
ALTER TABLE [dbo].[TObjectiveAudit] ADD CONSTRAINT [PK_TObjectiveAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TObjectiveAudit_ObjectiveId_ConcurrencyId] ON [dbo].[TObjectiveAudit] ([ObjectiveId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
