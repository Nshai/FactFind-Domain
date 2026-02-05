CREATE TABLE [dbo].[TTagAudit]
(
	[AuditId] [int] NOT NULL IDENTITY,	
	[TagId] INT NOT NULL, 
	[EntityType] VARCHAR(20) NOT NULL, 
	[EntityId] INT NOT NULL, 
	[Name] NVARCHAR(100) NOT NULL, 
	[TenantId] INT NOT NULL, 
	[CreatedTimeStamp] DATETIME NOT NULL,
	[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
	[StampDateTime] [datetime] NULL,
	[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)

ALTER TABLE [dbo].[TTagAudit] ADD CONSTRAINT [DF_TTagAudit_StampDateTime]
DEFAULT (getdate()) FOR [StampDateTime]