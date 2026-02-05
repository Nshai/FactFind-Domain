CREATE TABLE [dbo].[TFinancialPlanningScenarioAssetSplitsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[ScenarioId] [int] NOT NULL,
[Cash] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_TFinancialPlanningScenarioAssetSplitsAudit_Cash] DEFAULT ((0)),
[Property] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_TFinancialPlanningScenarioAssetSplitsAudit_Property] DEFAULT ((0)),
[FixedInterest] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_TFinancialPlanningScenarioAssetSplitsAudit_FixedInterest] DEFAULT ((0)),
[UKEquity] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_TFinancialPlanningScenarioAssetSplitsAudit_UKEquity] DEFAULT ((0)),
[OverseasEquity] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_TFinancialPlanningScenarioAssetSplitsAudit_OverseasEquity] DEFAULT ((0)),
[SpecialistEquity] [decimal] (18, 2) NOT NULL CONSTRAINT [DF_TFinancialPlanningScenarioAssetSplitsAudit_SpecialistEquity] DEFAULT ((0)),
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TFinancialPlanningScenarioAssetSplitsAudit_ConcurrencyId] DEFAULT ((1)),
[FinancialPlanningScenarioAssetSplitsId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFinancialPlanningScenarioAssetSplitsAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningScenarioAssetSplitsAudit] ADD CONSTRAINT [PK_TFinancialPlanningScenarioAssetSplitsAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFinancialPlanningScenarioAssetSplitsAudit_FinancialPlanningScenarioAssetSplitsId_ConcurrencyId] ON [dbo].[TFinancialPlanningScenarioAssetSplitsAudit] ([FinancialPlanningScenarioAssetSplitsId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
