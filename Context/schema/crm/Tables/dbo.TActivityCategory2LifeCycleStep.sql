CREATE TABLE [dbo].[TActivityCategory2LifeCycleStep]
(
[ActivityCategory2LifeCycleStepId] [int] NOT NULL IDENTITY(1, 1),
[LifeCycleStepId] [int] NOT NULL,
[ActivityCategoryId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TActivityCategory2LifeCycleStep_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TActivityCategory2LifeCycleStep] ADD CONSTRAINT [PK_TActivityCategory2LifeCycleStep] PRIMARY KEY CLUSTERED  ([ActivityCategory2LifeCycleStepId])
GO
ALTER TABLE [dbo].[TActivityCategory2LifeCycleStep] WITH CHECK ADD CONSTRAINT [FK_TActivityCategory2LifeCycleStep_TActivityCategory] FOREIGN KEY ([ActivityCategoryId]) REFERENCES [dbo].[TActivityCategory] ([ActivityCategoryId])
GO
