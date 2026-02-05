CREATE TABLE [dbo].[TLifeCycle2RefPlanType]
(
[LifeCycle2RefPlanTypeId] [int] NOT NULL IDENTITY(1, 1),
[LifeCycleId] [int] NOT NULL,
[RefPlanTypeId] [int] NOT NULL,
[AdviceTypeId] [int] NULL,
[ConcurrencyId] [char] (10)  NULL CONSTRAINT [DF_TLifeCycle2RefPlanType_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TLifeCycle2RefPlanType] ADD CONSTRAINT [PK_TLifeCycle2RefPlanType] PRIMARY KEY CLUSTERED  ([LifeCycle2RefPlanTypeId])
GO
CREATE NONCLUSTERED INDEX [IX_TLifeCycle2RefPlanType_LifeCycleIdASC] ON [dbo].[TLifeCycle2RefPlanType] ([LifeCycleId])
GO
CREATE NONCLUSTERED INDEX [IX_TLifeCycle2RefPlanType_RefPlanTypeIdASC] ON [dbo].[TLifeCycle2RefPlanType] ([RefPlanTypeId])
GO
CREATE NONCLUSTERED INDEX [IX_TLifeCycle2RefPlanType_RefPlanTypeId] ON [dbo].[TLifeCycle2RefPlanType] ([RefPlanTypeId]) INCLUDE ([AdviceTypeId])
GO
CREATE NONCLUSTERED INDEX [IX_TLifeCycle2RefPlanType_RefPlanTypeId_AdviceTypeId] ON [dbo].[TLifeCycle2RefPlanType] ([RefPlanTypeId], [AdviceTypeId])
GO
ALTER TABLE [dbo].[TLifeCycle2RefPlanType] WITH CHECK ADD CONSTRAINT [FK_TLifeCycle2RefPlanType_TLifeCycle] FOREIGN KEY ([LifeCycleId]) REFERENCES [dbo].[TLifeCycle] ([LifeCycleId])
GO
ALTER TABLE [dbo].[TLifeCycle2RefPlanType] WITH CHECK ADD CONSTRAINT [FK_TLifeCycle2RefPlanType_TRefPlanType] FOREIGN KEY ([RefPlanTypeId]) REFERENCES [dbo].[TRefPlanType] ([RefPlanTypeId])
GO
