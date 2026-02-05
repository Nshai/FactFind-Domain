CREATE TABLE [dbo].[TFinancialPlanningInvestmentAssetAllocationAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[InvestmentId] [int] NOT NULL,
[InvestmentType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Cash] [money] NULL CONSTRAINT [DF_TFinancialPlanningInvestmentAssetAllocationAudit_Cash] DEFAULT ((0)),
[Property] [money] NULL CONSTRAINT [DF_TFinancialPlanningInvestmentAssetAllocationAudit_Property] DEFAULT ((0)),
[FixedInterest] [money] NULL CONSTRAINT [DF_TFinancialPlanningInvestmentAssetAllocationAudit_FixedInterest] DEFAULT ((0)),
[UKEquities] [money] NULL CONSTRAINT [DF_TFinancialPlanningInvestmentAssetAllocationAudit_UKEquities] DEFAULT ((0)),
[OverseasEquities] [money] NULL CONSTRAINT [DF_TFinancialPlanningInvestmentAssetAllocationAudit_OverseasEquities] DEFAULT ((0)),
[SpecialistEquities] [money] NULL CONSTRAINT [DF_TFinancialPlanningInvestmentAssetAllocationAudit_SpecialistEquities] DEFAULT ((0)),
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TFinancialPlanningInvestmentAssetAllocationAudit_ConcurrencyId] DEFAULT ((1)),
[FinancialPlanningInvestmentAssetAllocationId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFinancialPlanningInvestmentAssetAllocationAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningInvestmentAssetAllocationAudit] ADD CONSTRAINT [PK_TFinancialPlanningInvestmentAssetAllocationAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFinancialPlanningInvestmentAssetAllocationAudit_FinancialPlanningInvestmentAssetAllocationId_ConcurrencyId] ON [dbo].[TFinancialPlanningInvestmentAssetAllocationAudit] ([FinancialPlanningInvestmentAssetAllocationId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
