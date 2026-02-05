CREATE TABLE [dbo].[TRefRecommendationSolutionStatus]
(
[RefRecommendationSolutionStatusId] [smallint] NOT NULL IDENTITY(1, 1),
[Status] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefRecommendationSolutionStatus_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefRecommendationSolutionStatus] ADD CONSTRAINT [PK_TRefRecommendationSolutionStatus] PRIMARY KEY CLUSTERED  ([RefRecommendationSolutionStatusId])
GO
