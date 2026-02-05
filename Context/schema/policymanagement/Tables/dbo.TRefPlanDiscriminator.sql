CREATE TABLE [dbo].[TRefPlanDiscriminator]
(
[RefPlanDiscriminatorId] [int] NOT NULL IDENTITY(1, 1),
[PlanDiscriminatorName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[ParentPlanDiscriminatorId] [int] NULL
)
GO
ALTER TABLE [dbo].[TRefPlanDiscriminator] ADD CONSTRAINT [PK_TRefPlanDiscriminator] PRIMARY KEY CLUSTERED ([RefPlanDiscriminatorId])
GO
