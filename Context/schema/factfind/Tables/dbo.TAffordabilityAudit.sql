CREATE TABLE [dbo].[TAffordabilityAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[MonthlyIncome] [money] NULL,
[MonthlyExpenditure] [money] NULL,
[MonthlyDispIncome] [money] NULL,
[MonthlyAfford] [money] NULL,
[LumpSumAfford] [money] NULL,
[InvestmentFundSource] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[EmergencyFundRequired] [money] NULL,
[PenaltyFreeFg] [bit] NULL,
[IncomeChangeFg] [bit] NULL,
[IncomeChangeNotes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[AffordabilityNotes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[AffordabilityId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TAffordabilityAudit__ConcurrencyId] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[IsIncomeChangeIncluded] [bit] NULL,
[IsExpenditureChangeIncluded] [bit] NULL,
[IsNonEssentialRemoved] [bit] NULL,
[IsLiabilityExpenditureConsolidated] [bit] NULL,
[IsProtectionRebroked] [bit] NULL,
[IsLiabilityExpenditureRepaid] [bit] NULL,
[MonthlyNotes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[AgreedBudgetAmount] [money] NULL,
[TotalFundsAvailable] [money] NULL,
[AmountSetAsideForShortTermNeeds] [money] NULL,
[AmountPutAsideForEmergencyFund] [money] NULL,
[EmergencyFundShortfall] [money] NULL
)
GO
ALTER TABLE [dbo].[TAffordabilityAudit] ADD CONSTRAINT [PK_TAffordabilityAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=75)
GO
CREATE NONCLUSTERED INDEX [IDX_TAffordabilityAudit_AffordabilityId_ConcurrencyId] ON [dbo].[TAffordabilityAudit] ([AffordabilityId], [ConcurrencyId]) WITH (FILLFACTOR=75)
GO
