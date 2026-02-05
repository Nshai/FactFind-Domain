CREATE TABLE [dbo].[TRefFinancialPlanningSessionStatus]
(
[RefFinancialPlanningSessionStatusId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TRefFinancialPlanningSessionStatus] ADD CONSTRAINT [PK_TRefFinancialPlanningSessionStatus] PRIMARY KEY CLUSTERED  ([RefFinancialPlanningSessionStatusId])
GO
