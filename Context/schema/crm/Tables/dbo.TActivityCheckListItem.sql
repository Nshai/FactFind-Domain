CREATE TABLE [TActivityCheckListItem]
(
    [ActivityCheckListItemId] INT NOT NULL IDENTITY(1,1),
    [CheckListItemId] INT NOT NULL,
    [ActivityCategoryId] INT NOT NULL,
    [IndigoClientId] INT NOT NULL,
    [Ordinal] INT NOT NULL,
    [CreatedAt] DATETIME NOT NULL,
    [CreatedBy] INT NOT NULL,
    [UpdatedAt] DATETIME NULL,
    [UpdatedBy] INT NULL

    CONSTRAINT PK_ActivityCheckListItemId PRIMARY KEY CLUSTERED (ActivityCheckListItemId)
);

GO
CREATE NONCLUSTERED INDEX [IDX_TActivityCheckListItem_ActivityCategoryId] ON [dbo].[TActivityCheckListItem] ([ActivityCategoryId])
GO
CREATE NONCLUSTERED INDEX [IX_TActivityCheckListItem_IndigoClientId] ON [dbo].[TActivityCheckListItem] ([IndigoClientId])
GO
CREATE NONCLUSTERED INDEX [IX_TActivityCheckListItem_CheckListItemId] ON [dbo].[TActivityCheckListItem] ([CheckListItemId])
GO
ALTER TABLE [dbo].[TActivityCheckListItem] ADD CONSTRAINT [FK_TActivityCheckListItem_CheckListItemId] FOREIGN KEY ([CheckListItemId]) REFERENCES [dbo].[TCheckListItem] ([CheckListItemId])
GO