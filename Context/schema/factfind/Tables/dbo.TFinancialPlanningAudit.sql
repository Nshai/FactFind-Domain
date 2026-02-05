CREATE TABLE [dbo].[TFinancialPlanningAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FactFindId] [int] NOT NULL,
[AdjustValue] [bit] NOT NULL CONSTRAINT [DF_TFinancialPlanningAudit_AdjustValue] DEFAULT ((1)),
[RefPlanningTypeId] [int] NOT NULL,
[RefInvestmentTypeId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningAudit_RefInvestmentTypeId] DEFAULT ((1)),
[IncludeAssets] [bit] NOT NULL CONSTRAINT [DF_TFinancialPlanningAudit_IncludeAssets] DEFAULT ((0)),
[RegularImmediateIncome] [bit] NOT NULL CONSTRAINT [DF_TFinancialPlanningAudit_RegularImmediateIncome] DEFAULT ((0)),
[IsArchived] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningAudit_ConcurrencyId] DEFAULT ((0)),
[FinancialPlanningId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFinancialPlanningAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[GoalType] [int] NULL,
[RefLumpsumAtRetirementTypeId] [int] NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningAudit] ADD CONSTRAINT [PK_TFinancialPlanningAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFinancialPlanningAudit_FinancialPlanningId_ConcurrencyId] ON [dbo].[TFinancialPlanningAudit] ([FinancialPlanningId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
