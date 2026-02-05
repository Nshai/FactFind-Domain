CREATE TABLE [dbo].[TFinancialPlanningNote]
(
[FinancialPlanningNoteId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningId] [int] NOT NULL,
[Notes] [varchar] (max) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TFinancialPlanningNote] ADD CONSTRAINT [PK_TFinancialPlanningNote] PRIMARY KEY CLUSTERED  ([FinancialPlanningNoteId])
GO
