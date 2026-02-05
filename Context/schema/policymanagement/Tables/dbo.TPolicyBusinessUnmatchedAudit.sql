CREATE TABLE [dbo].[TPolicyBusinessUnmatchedAudit]
(
     [AuditId] [int] NOT NULL IDENTITY(1, 1)
	,[PolicyBusinessUnmatchedId] [int] NOT NULL
	,[PolicyBusinessId] [int] NOT NULL
	,[TenantId] [int] NOT NULL
	,[AddressLine1] varchar(100) NULL
	,[AddressLine2] varchar(100) NULL
	,[AddressLine3] varchar(100) NULL
	,[AddressLine4] varchar(100) NULL
	,[CityTown] varchar(100) NULL
	,[Postcode] varchar(20) NULL
	,[CountryId] [int] NULL
	,[CountyId] [int] NULL
	,[AdviserName] varchar(255) NULL
	,[CreatedAt] [datetime] NOT NULL
	,[ChangedAt] [datetime] NULL
	,[MatchedAt] [datetime] NULL
	,[MatchedByUserId] [int] NULL
	,[StampAction] [char] (1) NOT NULL
    ,[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPolicyBusinessUnmatchedAudit_StampDateTime] DEFAULT (getdate())
    ,[StampUser] [varchar] (255) NULL,
)
GO
ALTER TABLE [dbo].[TPolicyBusinessUnmatchedAudit] ADD CONSTRAINT [PK_TPolicyBusinessUnmatchedAudit] PRIMARY KEY ([AuditId]) 
GO