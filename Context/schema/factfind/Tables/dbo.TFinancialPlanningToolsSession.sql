CREATE TABLE [dbo].[TFinancialPlanningToolsSession]
(
[FinancialPlanningToolsSessionId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NULL,
[BaseTemplateGuid] [uniqueidentifier] NULL,
[AtrRefProfilePreferenceId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TFinancialPlanningToolsSession_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TFinancialPlanningToolsSession] ADD CONSTRAINT [PK_TFinancialPlanningToolsSession] PRIMARY KEY CLUSTERED  ([FinancialPlanningToolsSessionId])
GO
