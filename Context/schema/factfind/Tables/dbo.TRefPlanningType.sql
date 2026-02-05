CREATE TABLE [dbo].[TRefPlanningType]
(
[RefPlanningTypeId] [int] NOT NULL IDENTITY(1, 1),
[PlanningType] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPlanningType_ConcurrencyId] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TRefPlanningType] ADD CONSTRAINT [PK_TRefPlanningType] PRIMARY KEY NONCLUSTERED  ([RefPlanningTypeId])
GO
