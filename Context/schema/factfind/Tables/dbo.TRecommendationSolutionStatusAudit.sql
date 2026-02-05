CREATE TABLE [dbo].[TRecommendationSolutionStatusAudit]
(
[RecommendationSolutionStatusAuditId] [int] NOT NULL IDENTITY(1, 1),
[RecommendationSolutionStatusId] [int] NULL,
[FinancialPlanningSessionId] [int] NULL,
[SolutionGroup] [int] NULL,
[RefRecommendationSolutionStatusId] [smallint] NULL,
[StatusChangeDate] [datetime] NULL,
[ConcurrencyId] [smallint] NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[TenantId] [int] NULL,
[FinancialPlanningScenarioId] [int] NULL,
[RecommendationName] [nvarchar](100) NULL
)
GO
ALTER TABLE [dbo].[TRecommendationSolutionStatusAudit] ADD CONSTRAINT [PK_TRecommendationSolutionStatusAudit] PRIMARY KEY CLUSTERED  ([RecommendationSolutionStatusAuditId])
GO
