
Create Table TFileImportHeaderAudit
(
	[AuditId] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
	TenantId int Not Null,
	UserId int Not Null,
	EntryDate datetime  Not Null,
	LastUpdatedDate datetime  Not Null,
	HeaderData varchar(max) Null,
	ShouldRecordsBeDuplicated bit Null,
	[Status] varchar(100) Not Null,
	IsBeingProcessed bit Null,
	NumberOfRecords int,
	NumberOfRecordsFailed int,
	NumberOfRecordsDuplicated int,
	EncodedSerialisedCustomData varchar(max),
	EncodedSerialisedCustomDataTypeString varchar(max),
	[Message] varchar(max),
	[SystemMessage] varchar(max),
	[FileId] varchar(2000),
	[OriginalFileName] varchar(2000),
	[FileImportType] varchar(2000),
	MigrationId  varchar(1000),
	[EstimatedRecordsProcessedPerSecond] [decimal] (8, 2),
	FileImportHeaderId uniqueidentifier Not Null,
	[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
	[StampDateTime] [datetime] NULL CONSTRAINT [DF_TFileImportHeaderAudit_StampDateTime] DEFAULT (getdate()),
	[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
	CONSTRAINT [PK_TFileImportHeaderAudit] PRIMARY KEY CLUSTERED ( [AuditId] ASC )
)
GO

ALTER TABLE [dbo].[TFileImportHeaderAudit]
ADD CONSTRAINT DF_TFileImportHeaderAudit_EntryDate DEFAULT (getdate())  FOR [EntryDate]
GO

ALTER TABLE [dbo].[TFileImportHeaderAudit]
ADD CONSTRAINT DF_TFileImportHeaderAudit_LastUpdatedDate DEFAULT (getdate())  FOR [LastUpdatedDate]
GO
