CREATE TABLE [dbo].[TRefRecommendationStatus]
(
[RefRecommendationStatusId] [int] NOT NULL IDENTITY(1, 1),
[Identifier] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NULL
)
GO
ALTER TABLE [dbo].[TRefRecommendationStatus] ADD CONSTRAINT [PK_TRefRecommendationStatus] PRIMARY KEY CLUSTERED  ([RefRecommendationStatusId])
GO
