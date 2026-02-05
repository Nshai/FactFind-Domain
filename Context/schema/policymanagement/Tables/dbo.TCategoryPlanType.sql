CREATE TABLE [dbo].[TCategoryPlanType]
(
[CategoryPlanTypeId] [int] NOT NULL IDENTITY(1, 1),
[PlanCategoryId] [int] NOT NULL,
[RefPlanTypeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPlanCategoryPlanType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TCategoryPlanType] ADD CONSTRAINT [PK_TPlanCategoryPlanType] PRIMARY KEY NONCLUSTERED  ([CategoryPlanTypeId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TCategoryPlanType_PlanCategoryId] ON [dbo].[TCategoryPlanType] ([PlanCategoryId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TCategoryPlanType_RefPlanTypeId] ON [dbo].[TCategoryPlanType] ([RefPlanTypeId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TCategoryPlanType] ADD CONSTRAINT [FK_TCategoryPlanType_PlanCategoryId_PlanCategoryId] FOREIGN KEY ([PlanCategoryId]) REFERENCES [dbo].[TPlanCategory] ([PlanCategoryId])
GO
ALTER TABLE [dbo].[TCategoryPlanType] ADD CONSTRAINT [FK_TCategoryPlanType_RefPlanTypeId_RefPlanTypeId] FOREIGN KEY ([RefPlanTypeId]) REFERENCES [dbo].[TRefPlanType] ([RefPlanTypeId])
GO
