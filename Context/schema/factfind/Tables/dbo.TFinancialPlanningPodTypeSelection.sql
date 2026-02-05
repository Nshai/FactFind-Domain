CREATE TABLE [dbo].[TFinancialPlanningPodTypeSelection]
(
[FinancialPlanningPodTypeSelectionId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[RefFinancialPlanningPodTypeId] [nchar] (10) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningPodTypeSelection_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TFinancialPlanningPodTypeSelection] ADD CONSTRAINT [PK_TFinancialPlanningPodTypeSelection] PRIMARY KEY CLUSTERED  ([FinancialPlanningPodTypeSelectionId])
GO
