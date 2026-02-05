CREATE TABLE [dbo].[TRefPlanType2Workflows]
(
[WorkFlow2RefPlanType] [int] NOT NULL IDENTITY(1, 1),
[AdviceType] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[PlanTypeName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[RefPlanTypeId] [int] NULL
)
GO
ALTER TABLE [dbo].[TRefPlanType2Workflows] ADD CONSTRAINT [PK_TRefPlanType2Workflows] PRIMARY KEY CLUSTERED  ([WorkFlow2RefPlanType]) WITH (FILLFACTOR=80)
GO
