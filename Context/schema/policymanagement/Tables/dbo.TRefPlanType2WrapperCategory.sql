CREATE TABLE [dbo].[TRefPlanType2WrapperCategory]
(
[RefPlanType2WrapperCategoryId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[RefPlanType2ProdSubTypeId] [int] NOT NULL,
[PlanName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[WrapperCategory] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[TRefPlanType2WrapperCategory] ADD CONSTRAINT [PK_TRefPlanType2WrapperCategory] PRIMARY KEY CLUSTERED  ([RefPlanType2WrapperCategoryId])
GO
