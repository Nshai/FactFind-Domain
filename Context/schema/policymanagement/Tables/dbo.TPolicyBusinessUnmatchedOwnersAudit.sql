CREATE TABLE [dbo].[TPolicyBusinessUnmatchedOwnersAudit]
(
     [AuditId] [int] NOT NULL IDENTITY(1, 1)
	,[PolicyBusinessUnmatchedOwnersId] [int] NOT NULL 
	,[PolicyBusinessUnmatchedId] [int] NOT NULL
	,[FirstName] varchar(100) NULL
	,[LastName] varchar(100) NULL
	,[Name] varchar(100) NULL
	,[ExternalReference] varchar(60) NULL
	,[Role] varchar(40) NULL
	,[Status] varchar(20) NULL
	,[StampAction] [char] (1) NOT NULL
    ,[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPolicyBusinessUnmatchedOwnersAudit_StampDateTime] DEFAULT (getdate())
    ,[StampUser] [varchar] (255) NULL,
)
GO
ALTER TABLE [dbo].[TPolicyBusinessUnmatchedOwnersAudit] ADD CONSTRAINT [PK_TPolicyBusinessUnmatchedOwnersAudit] PRIMARY KEY ([AuditId]) 
GO