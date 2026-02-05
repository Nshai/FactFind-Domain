CREATE TABLE [dbo].[TObjective]
(
[ObjectiveId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Objective] [varchar] (500) COLLATE Latin1_General_CI_AS NULL,
[TargetAmount] [money] NULL,
[StartDate] [datetime] NULL,
[TargetDate] [datetime] NULL,
[RegularImmediateIncome] [bit] NULL,
[ReasonForChange] [varchar] (200) COLLATE Latin1_General_CI_AS NULL,
[RiskProfileGuid] [uniqueidentifier] NULL,
[CRMContactId] [int] NULL,
[ObjectiveTypeId] [int] NOT NULL,
[IsFactFind] [bit] NOT NULL CONSTRAINT [DF_TObjective_IsFactFind] DEFAULT ((0)),
[Details] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[Frequency] [int] NULL,
[RetirementAge] [int] NULL,
[LumpSumAtRetirement] [money] NULL,
[AnnualPensionIncome] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TObjective_ConcurrencyId] DEFAULT ((1)),
[CRMContactId2] [int] NULL,
[GoalType] [tinyint] NULL,
[RiskDiscrepency] [int] NULL,
[RiskProfileAdjustedDate] [datetime] NULL,
[RefLumpsumAtRetirementTypeId] [int] NOT NULL CONSTRAINT [DF_TObjective_RefLumpsumAtRetirementTypeId] DEFAULT ((1)),
[RefGoalCategoryId] [int] NULL,
[RefIncreaseRateId] [int] NULL,
[MarkedAsCompletedDate] [datetime] NULL,
[AccountId] [int] NULL,
[PlanId] [int] NULL,
[IsCreatedByClient] [bit] NOT NULL CONSTRAINT [DF_TObjective_IsCreatedByClient] DEFAULT ((0)),
[MarkedAsCompletedByUserId] [int] NULL,
[IsAtRetirement] [bit] NULL,
[TermInYears] [tinyint] NULL
)
GO
ALTER TABLE [dbo].[TObjective] ADD CONSTRAINT [PK_TObjective] PRIMARY KEY NONCLUSTERED  ([ObjectiveId])
GO
CREATE NONCLUSTERED INDEX [IX_TObjective_CRMContactId] ON [dbo].[TObjective] ([CRMContactId])
GO
CREATE NONCLUSTERED INDEX [IX_TObjective_CRMContactId2] ON [dbo].[TObjective] ([CRMContactId2])
GO