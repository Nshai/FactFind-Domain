CREATE TABLE [dbo].[TRefFactFindCategoryPlanType]
(
[RefFactFindCategoryPlanTypeId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[Category] [varchar] (24) COLLATE Latin1_General_CI_AS NULL,
[RefFactFindCategoryId] [int] NULL,
[RefPlanTypeId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefFactFindCategoryPlanType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefFactFindCategoryPlanType] ADD CONSTRAINT [PK_TRefFactFindCategoryPlanType] PRIMARY KEY NONCLUSTERED  ([RefFactFindCategoryPlanTypeId]) WITH (FILLFACTOR=80)
GO
