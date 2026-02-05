CREATE TABLE [dbo].[TFinancialPlanningExt]
(
[FinancialPlanningExtId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[PensionIncrease] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[SpousePercentage] [int] NULL,
[GuaranteePeriod] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[StatePension] [bit] NULL CONSTRAINT [DF_TFinancialPlanningExt_StatePension] DEFAULT ((0)),
[DefaultLumpSum] [money] NULL,
[DefaultMonthlyPremium] [money] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningExt_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TFinancialPlanningExt] ADD CONSTRAINT [PK_TFinancialPlanningExt] PRIMARY KEY NONCLUSTERED  ([FinancialPlanningExtId])
GO
CREATE NONCLUSTERED INDEX IX_TFinancialPlanningExt_FinancialPlanningId ON [dbo].[TFinancialPlanningExt] ([FinancialPlanningId])
GO