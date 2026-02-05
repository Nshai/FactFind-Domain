CREATE TABLE [dbo].[TRefPlanType2ProdSubTypeCategory]
(
[RefPlanType2ProdSubTypeCategoryId] [int] NOT NULL IDENTITY(1, 1),
[IndigoClientId] [int] NOT NULL,
[RefPlanType2ProdSubTypeId] [int] NULL,
[PlanCategoryId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TRefPlanType2ProdSubTypeCategory_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TRefPlanType2ProdSubTypeCategory] ADD CONSTRAINT [PK_TRefPlanType2ProdSubTypeCategory] PRIMARY KEY CLUSTERED  ([RefPlanType2ProdSubTypeCategoryId])
GO
CREATE NONCLUSTERED INDEX [IX_TRefPlanType2ProdSubTypeCategory_RefPlanType2ProdSubTypeId] ON [dbo].[TRefPlanType2ProdSubTypeCategory] ([RefPlanType2ProdSubTypeId]) INCLUDE ([PlanCategoryId], [RefPlanType2ProdSubTypeCategoryId])
GO
CREATE NONCLUSTERED INDEX [IX_TRefPlanType2ProdSubTypeCategory_IndigoClientId_RefPlanType2ProdSubTypeId] ON [dbo].[TRefPlanType2ProdSubTypeCategory] ([IndigoClientId], [RefPlanType2ProdSubTypeId]) 
GO