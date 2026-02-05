CREATE TABLE [dbo].[TActivityCategoryHidden]
(
[ActivityCategoryHiddenId] [int] NOT NULL IDENTITY(1, 1),
[ActivityCategoryId] [int] NOT NULL,
[GroupId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TActivityCategoryHidden_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TActivityCategoryHidden] ADD CONSTRAINT [PK_TActivityCategoryHidden] PRIMARY KEY CLUSTERED  ([ActivityCategoryHiddenId])
GO
CREATE NONCLUSTERED INDEX [IX_TActivityCategoryHidden_GroupId] ON [dbo].[TActivityCategoryHidden] ([GroupId])
GO
CREATE NONCLUSTERED INDEX [IX_TActivityCategoryHidden_TenantId] ON [dbo].[TActivityCategoryHidden] ([TenantId])
GO
ALTER TABLE [dbo].[TActivityCategoryHidden] ADD CONSTRAINT [FK_TActivityCategoryHidden_TActivityCategory] FOREIGN KEY ([ActivityCategoryId]) REFERENCES [dbo].[TActivityCategory] ([ActivityCategoryId]) ON DELETE CASCADE
GO
