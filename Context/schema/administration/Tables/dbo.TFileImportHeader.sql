
Create Table TFileImportHeader
(
	FileImportHeaderId uniqueidentifier Not Null,
	TenantId int Not Null,
	UserId int Not Null,
	EntryDate datetime  Not Null,
	LastUpdatedDate datetime  Not Null,
	HeaderData varchar(max) Null,
	ShouldRecordsBeDuplicated bit Null,
	[Status] varchar(100) Not Null,
	IsBeingProcessed bit Not Null,
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
	[EstimatedRecordsProcessedPerSecond] [decimal] (8, 2) NOT NULL,
	CONSTRAINT [PK_TFileImportHeader] PRIMARY KEY CLUSTERED ( [FileImportHeaderId] ASC )
)
GO

ALTER TABLE [dbo].[TFileImportHeader]
ADD CONSTRAINT DF_TFileImportHeader_EntryDate DEFAULT (getdate())  FOR [EntryDate]
GO

ALTER TABLE [dbo].[TFileImportHeader]
ADD CONSTRAINT DF_TFileImportHeader_LastUpdatedDate DEFAULT (getdate())  FOR [LastUpdatedDate]
GO

ALTER TABLE [dbo].[TFileImportHeader]
ADD CONSTRAINT DF_TFileImportHeader_IsBeingProcessed DEFAULT (0)  FOR [IsBeingProcessed]
GO

ALTER TABLE [dbo].[TFileImportHeader]
ADD CONSTRAINT DF_TFileImportHeader_EstimatedRecordsProcessedPerSecond DEFAULT (0)  FOR [EstimatedRecordsProcessedPerSecond]
GO

CREATE NONCLUSTERED INDEX [IX_TFileImportHeader_UserId_FileImportHeaderId_TenantId_EntryDate] ON [dbo].[TFileImportHeader] 
(
	[UserId] ASC,
	[FileImportHeaderId] ASC,
	[TenantId] ASC,
	[EntryDate] ASC
)
INCLUDE ( [Status],
[NumberOfRecords],
[OriginalFileName],
[FileImportType]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
