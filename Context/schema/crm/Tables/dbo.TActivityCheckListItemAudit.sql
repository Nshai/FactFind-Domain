CREATE TABLE [dbo].[TActivityCheckListItemAudit]
(
	[AuditId] [int] NOT NULL IDENTITY(1, 1),
	[ActivityCheckListItemId] INT NOT NULL,
	[CheckListItemId] INT NOT NULL,
	[ActivityCategoryId] INT NOT NULL,
	[IndigoClientId] INT NOT NULL,
	[Ordinal] INT NOT NULL,
	[CreatedAt] DATETIME NOT NULL,
	[CreatedBy] INT NOT NULL,
	[UpdatedAt] DATETIME NULL,
	[UpdatedBy] INT NULL,
	[StampAction] [char] (1) NOT NULL,
	[StampDateTime] [datetime] NULL CONSTRAINT [DF_TActivityCheckListItemAudit_StampDateTime] DEFAULT (getdate()),
	[StampUser] [varchar] (255) NULL
)
GO
ALTER TABLE [dbo].[TActivityCheckListItemAudit] ADD CONSTRAINT PK_TActivityCheckListItemAudit PRIMARY KEY CLUSTERED ([AuditId])
GO