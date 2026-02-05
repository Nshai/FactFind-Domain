Create Table TFileImportItemAudit
(
	[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
	FileImportHeaderId uniqueidentifier Not Null,
	RowNumber int Not Null,
	RowData varchar(max) Not Null,
	[Status] varchar(100) Not Null,
	DuplicateHash varchar(max),
	[Message] varchar(max),
	[SystemMessage] varchar(max),
	[CreatedId] varchar(1000),
	[ResourceHref] varchar(256) NULL,
	MigrationId  varchar(1000),
	LastUpdatedDate datetime Null,
	FileImportItemId uniqueidentifier Not Null,
	[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
	[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFileImportItemAudit_StampDateTime] DEFAULT (getdate()),
	[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
	CONSTRAINT [PK_TFileImportItemAudit] PRIMARY KEY CLUSTERED (	[AuditId] ASC )
)
