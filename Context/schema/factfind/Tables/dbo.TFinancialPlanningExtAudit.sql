CREATE TABLE [dbo].[TFinancialPlanningExtAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[PensionIncrease] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[SpousePercentage] [int] NULL,
[GuaranteePeriod] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[StatePension] [bit] NULL,
[DefaultLumpSum] [money] NULL,
[DefaultMonthlyPremium] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningExtAudit_ConcurrencyId] DEFAULT ((0)),
[FinancialPlanningExtId] [int] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFinancialPlanningExtAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningExtAudit] ADD CONSTRAINT [PK_TFinancialPlanningExtAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TFinancialPlanningExtAudit_FinancialPlanningExtId_ConcurrencyId] ON [dbo].[TFinancialPlanningExtAudit] ([FinancialPlanningExtId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
