CREATE TABLE [dbo].[TRetirementObjectiveAuditDELETE]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Objective] [varchar] (500) COLLATE Latin1_General_CI_AS NULL,
[TargetAmount] [money] NULL,
[StartDate] [datetime] NULL,
[TargetDate] [datetime] NULL,
[RegularImmediateIncome] [bit] NULL,
[ReasonForChange] [varchar] (200) COLLATE Latin1_General_CI_AS NULL,
[RiskProfileGuid] [uniqueidentifier] NULL,
[CRMContactId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRetirementObjectiveAudit_ConcurrencyId] DEFAULT ((1)),
[RetirementObjectiveId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TRetirementObjectiveAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TRetirementObjectiveAuditDELETE] ADD CONSTRAINT [PK_TRetirementObjectiveAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TRetirementObjectiveAudit_RetirementObjectiveId_ConcurrencyId] ON [dbo].[TRetirementObjectiveAuditDELETE] ([RetirementObjectiveId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
