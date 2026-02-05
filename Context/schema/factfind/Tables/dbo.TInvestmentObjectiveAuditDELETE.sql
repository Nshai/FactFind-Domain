CREATE TABLE [dbo].[TInvestmentObjectiveAuditDELETE]
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
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TInvestmentObjectiveAudit_ConcurrencyId] DEFAULT ((1)),
[InvestmentObjectiveId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TInvestmentObjectiveAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TInvestmentObjectiveAuditDELETE] ADD CONSTRAINT [PK_TInvestmentObjectiveAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TInvestmentObjectiveAudit_InvestmentObjectiveId_ConcurrencyId] ON [dbo].[TInvestmentObjectiveAuditDELETE] ([InvestmentObjectiveId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
