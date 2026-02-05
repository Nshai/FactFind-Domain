CREATE TABLE [dbo].[TActivityTaskCheckListItemAudit]
(
    [AuditId] [int] NOT NULL IDENTITY(1, 1),
    [ActivityTaskCheckListItemId] INT NOT NULL,
    [CheckListItemId] INT NOT NULL,
    [TaskId] INT NOT NULL,
    [ActivityCategoryId] INT NOT NULL,
    [IsCompleted] BIT NOT NULL DEFAULT 0,
    [IndigoClientId] INT NOT NULL,
    [CompletedAt] DATETIME NULL,
    [CompletedBy] INT NULL,
    [UpdatedAt] DATETIME NULL,
    [UpdatedBy] INT NULL,
    [StampAction] [char] (1) NOT NULL,
    [StampDateTime] [datetime] NULL CONSTRAINT [DF_TActivityTaskCheckListItemAudit_StampDateTime] DEFAULT (getdate()),
    [StampUser] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TActivityTaskCheckListItemAudit] ADD CONSTRAINT PK_TActivityTaskCheckListItemAudit PRIMARY KEY CLUSTERED ([AuditId])
GO