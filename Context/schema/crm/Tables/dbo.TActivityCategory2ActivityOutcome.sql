CREATE TABLE [dbo].[TActivityCategory2ActivityOutcome]
(
[ActivityCategory2ActivityOutcomeId] [int] NOT NULL IDENTITY(1, 1),
[ActivityCategoryId] [int] NOT NULL,
[ActivityOutcomeId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TActivityCategory2ActivityOutcome_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TActivityCategory2ActivityOutcome] ADD CONSTRAINT [PK_TActivityCategory2ActivityOutcome] PRIMARY KEY CLUSTERED  ([ActivityCategory2ActivityOutcomeId])
GO
CREATE NONCLUSTERED INDEX [IX_TActivityCategory2ActivityOutcome_ActivityCategoryIdASC] ON [dbo].[TActivityCategory2ActivityOutcome] ([ActivityCategoryId])
GO
CREATE NONCLUSTERED INDEX [IX_TActivityCategory2ActivityOutcome_ActivityOutcomeIdASC] ON [dbo].[TActivityCategory2ActivityOutcome] ([ActivityOutcomeId])
GO
ALTER TABLE [dbo].[TActivityCategory2ActivityOutcome] WITH CHECK ADD CONSTRAINT [FK_TActivityCategory2ActivityOutcome_ActivityCategoryId_ActivityCategoryId] FOREIGN KEY ([ActivityCategoryId]) REFERENCES [dbo].[TActivityCategory] ([ActivityCategoryId])
GO
ALTER TABLE [dbo].[TActivityCategory2ActivityOutcome] ADD CONSTRAINT [FK_TActivityCategory2ActivityOutcome_ActivityOutcomeId_ActivityOutcomeId] FOREIGN KEY ([ActivityOutcomeId]) REFERENCES [dbo].[TActivityOutcome] ([ActivityOutcomeId])
GO
