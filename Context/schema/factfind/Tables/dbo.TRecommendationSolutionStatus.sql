CREATE TABLE [dbo].[TRecommendationSolutionStatus]
(
[RecommendationSolutionStatusId] [int] NOT NULL IDENTITY(1, 1),
[FinancialPlanningSessionId] [int] NOT NULL,
[SolutionGroup] [int] NOT NULL,
[RefRecommendationSolutionStatusId] [smallint] NOT NULL,
[ConcurrencyId] [smallint] NOT NULL CONSTRAINT [DF_TRecommendationSolutionStatus_ConcurrencyId] DEFAULT ((1)),
[StatusChangeDate] [datetime] NULL,
[TenantId] [int] NULL,
[FinancialPlanningScenarioId] [int] NULL,
[RecommendationName] [nvarchar](100) NULL
)
GO
ALTER TABLE [dbo].[TRecommendationSolutionStatus] ADD CONSTRAINT [PK_TRecommendationSolutionStatus] PRIMARY KEY CLUSTERED  ([RecommendationSolutionStatusId])
GO
CREATE NONCLUSTERED INDEX IX_TRecommendationSolutionStatus_TenantId ON [dbo].TRecommendationSolutionStatus (TenantId)
INCLUDE ([FinancialPlanningSessionId],[SolutionGroup],[RefRecommendationSolutionStatusId],[StatusChangeDate],[RecommendationName])
GO