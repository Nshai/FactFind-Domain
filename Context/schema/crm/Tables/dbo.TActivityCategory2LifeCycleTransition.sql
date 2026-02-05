CREATE TABLE [dbo].[TActivityCategory2LifeCycleTransition]
(
[ActivityCategory2LifeCycleTransitionId] [int] NOT NULL IDENTITY(1, 1),
[LifeCycleTransitionId] [int] NOT NULL,
[ActivityCategoryId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TActivityCategory2LifeCycleTransition_ConcurrencyId] DEFAULT ((1)),
[CheckOutcome] [int] NOT NULL CONSTRAINT [DF_TActivityCategory2LifeCycleTransition_CheckOutCome] DEFAULT ((0)),
[CheckDueDate] [int] NOT NULL CONSTRAINT [DF_TActivityCategory2LifeCycleTransition_CheckDueDate] DEFAULT ((0))
)
GO
ALTER TABLE [dbo].[TActivityCategory2LifeCycleTransition] ADD CONSTRAINT [PK_TActivityCategory2LifeCycleTransition] PRIMARY KEY CLUSTERED  ([ActivityCategory2LifeCycleTransitionId])
GO
CREATE NONCLUSTERED INDEX [IX_TActivityCategory2LifeCycleTransition_ActivityCategoryIdASC] ON [dbo].[TActivityCategory2LifeCycleTransition] ([ActivityCategoryId])
GO
ALTER TABLE [dbo].[TActivityCategory2LifeCycleTransition] WITH CHECK ADD CONSTRAINT [FK_TActivityCategory2LifeCycleTransition_TActivityCategory] FOREIGN KEY ([ActivityCategoryId]) REFERENCES [dbo].[TActivityCategory] ([ActivityCategoryId])
GO
CREATE NONCLUSTERED INDEX IX_TActivityCategory2LifeCycleTransition_LifeCycleTransitionId ON [dbo].[TActivityCategory2LifeCycleTransition] ([LifeCycleTransitionId])
GO
