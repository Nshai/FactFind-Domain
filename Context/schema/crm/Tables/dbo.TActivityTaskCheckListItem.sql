CREATE TABLE [TActivityTaskCheckListItem]
(
    [ActivityTaskCheckListItemId] INT NOT NULL IDENTITY(1,1),
    [CheckListItemId] INT NOT NULL,
    [TaskId] INT NOT NULL,
    [ActivityCategoryId] INT NOT NULL,
    [IsCompleted] BIT NOT NULL CONSTRAINT [DF_TActivityTaskCheckListItem_IsCompleted] DEFAULT 0,
    [IndigoClientId] INT NOT NULL,
    [CompletedAt] DATETIME NULL,
    [CompletedBy] INT NULL,
    [UpdatedAt] DATETIME NULL,
    [UpdatedBy] INT NULL

    CONSTRAINT PK_ActivityTaskCheckListItemId PRIMARY KEY CLUSTERED (ActivityTaskCheckListItemId)
);

GO
CREATE NONCLUSTERED INDEX [IDX_TActivityTaskCheckListItem_TaskId] ON [dbo].[TActivityTaskCheckListItem] ([TaskId])
GO
CREATE NONCLUSTERED INDEX [IX_TActivityTaskCheckListItem_IndigoClientId] ON [dbo].[TActivityTaskCheckListItem] ([IndigoClientId])
GO
CREATE NONCLUSTERED INDEX [IX_TActivityTaskCheckListItem_CheckListItemId] ON [dbo].[TActivityTaskCheckListItem] ([CheckListItemId])
GO
ALTER TABLE [dbo].[TActivityTaskCheckListItem] ADD CONSTRAINT [FK_TActivityTaskCheckListItem_CheckListItemId] FOREIGN KEY ([CheckListItemId]) REFERENCES [dbo].[TCheckListItem] ([CheckListItemId])
ALTER TABLE [dbo].[TActivityTaskCheckListItem] ADD CONSTRAINT [FK_TActivityTaskCheckListItem_ActivityCategoryId] FOREIGN KEY ([ActivityCategoryId]) REFERENCES [dbo].[TActivityCategory] ([ActivityCategoryId])
ALTER TABLE [dbo].[TActivityTaskCheckListItem] ADD CONSTRAINT UQ_TActivityTaskCheckListItem_CheckList_Task_Category UNIQUE (CheckListItemId, TaskId, ActivityCategoryId);
GO