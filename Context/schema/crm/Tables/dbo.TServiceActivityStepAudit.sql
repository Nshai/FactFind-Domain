CREATE TABLE [dbo].[TServiceActivityStepAudit] 
(
    [AuditId] [int] NOT NULL IDENTITY(1, 1),
    [ServiceActivityId] INT NOT NULL,
    [Name] VARCHAR(100) NOT NULL,
    [DisplayName] VARCHAR(100) NULL,
    [Href] VARCHAR(200) NULL,
    [Status] VARCHAR(50) NULL,
    [StartedAt] DATETIME NULL,
    [LastUpdatedAt] DATETIME NULL,
    [LastUpdatedBy] INT NULL,
    [CompletedAt] DATETIME NULL,
    [CompletedBy] INT NULL,
    [StampAction] [char] (1) NOT NULL,
    [StampDateTime] [datetime] NULL CONSTRAINT [DF_TServiceActivityStepAudit_StampDateTime] DEFAULT (getdate()),
    [StampUser] [varchar] (255) NULL,
)
GO
ALTER TABLE [dbo].[TServiceActivityStepAudit] ADD CONSTRAINT PK_TServiceActivityStepAudit PRIMARY KEY CLUSTERED ([AuditId])
GO