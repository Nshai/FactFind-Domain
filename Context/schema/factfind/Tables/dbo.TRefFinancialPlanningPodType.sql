CREATE TABLE [dbo].[TRefFinancialPlanningPodType]
(
[RefFinancialPlanningPodTypeId] [int] NOT NULL IDENTITY(1, 1),
[Description] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[PodImageType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefFinancialPlanningPodType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefFinancialPlanningPodType] ADD CONSTRAINT [PK_TRefFinancialPlanningPodType] PRIMARY KEY CLUSTERED  ([RefFinancialPlanningPodTypeId])
GO
