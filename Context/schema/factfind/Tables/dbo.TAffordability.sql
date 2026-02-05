CREATE TABLE [dbo].[TAffordability]
(
[AffordabilityId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CRMContactId] [int] NOT NULL,
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
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TAffordability_ConcurrencyId] DEFAULT ((1)),
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
ALTER TABLE [dbo].[TAffordability] ADD CONSTRAINT [PK_TAffordability] PRIMARY KEY NONCLUSTERED  ([AffordabilityId]) WITH (FILLFACTOR=75)
GO
CREATE NONCLUSTERED INDEX [IDX_TAffordability_CRMContactId] ON [dbo].[TAffordability] ([CRMContactId])
GO
CREATE CLUSTERED INDEX [IX_TAffordability_CRMContactId] ON [dbo].[TAffordability] ([CRMContactId]) WITH (FILLFACTOR=75)
GO
