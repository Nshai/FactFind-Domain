CREATE TABLE [dbo].[TRetirementObjectiveDELETE]
(
[RetirementObjectiveId] [int] NOT NULL IDENTITY(1, 1),
[Objective] [varchar] (500) COLLATE Latin1_General_CI_AS NULL,
[TargetAmount] [money] NULL,
[StartDate] [datetime] NULL,
[TargetDate] [datetime] NULL,
[RegularImmediateIncome] [bit] NULL,
[ReasonForChange] [varchar] (200) COLLATE Latin1_General_CI_AS NULL,
[RiskProfileGuid] [uniqueidentifier] NULL,
[CRMContactId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRetirementObjective_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRetirementObjectiveDELETE] ADD CONSTRAINT [PK_TRetirementObjective] PRIMARY KEY NONCLUSTERED  ([RetirementObjectiveId]) WITH (FILLFACTOR=80)
GO
