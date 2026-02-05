CREATE TABLE [dbo].[TCheckListItem]
(
    [CheckListItemId] INT NOT NULL IDENTITY(1,1),
    [IndigoClientId] INT NOT NULL,
    [GroupId] INT NULL,
    [Name] VARCHAR(100) NOT NULL,
    [IsArchived] BIT NOT NULL CONSTRAINT [DF_TCheckListItem_IsArchived] DEFAULT ((0)),
    [CreatedAt] DATETIME NOT NULL,
    [CreatedBy] INT NOT NULL,
    [UpdatedAt] DATETIME NULL,
    [UpdatedBy] INT NULL

    CONSTRAINT [PK_TCheckListItemId] PRIMARY KEY CLUSTERED (CheckListItemId)
);
GO
CREATE NONCLUSTERED INDEX [IX_CheckLists_IndigoClientId] ON [dbo].[TCheckListItem] ([IndigoClientId])
GO
CREATE NONCLUSTERED INDEX [IX_CheckLists_GroupId] ON [dbo].[TCheckListItem] ([GroupId])
GO