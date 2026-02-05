CREATE TABLE [dbo].[TCheckListItemAudit]
(
    [AuditId] [int] NOT NULL IDENTITY(1, 1),
    [IndigoClientId] INT NOT NULL,
    [GroupId] INT NULL,
    [Name] VARCHAR(100) NOT NULL,
    [IsArchived] BIT NOT NULL,
    [CreatedAt] DATETIME NOT NULL,
    [CreatedBy] INT NOT NULL,
    [UpdatedAt] DATETIME NULL,
    [UpdatedBy] INT NULL,
    [CheckListItemId] [int] NOT NULL,
    [StampAction] [char] (1) NOT NULL,
    [StampDateTime] [datetime] NULL CONSTRAINT [DF_TCheckListItemAudit_StampDateTime] DEFAULT (getdate()),
    [StampUser] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TCheckListItemAudit] ADD CONSTRAINT PK_TCheckListItemAudit PRIMARY KEY CLUSTERED ([AuditId])
GO