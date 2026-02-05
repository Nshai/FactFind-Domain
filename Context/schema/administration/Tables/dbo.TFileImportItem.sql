Create Table TFileImportItem
(
	FileImportItemId uniqueidentifier Not Null,
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
	CONSTRAINT [PK_TFileImportItem] PRIMARY KEY CLUSTERED (	[FileImportItemId] ASC )
)
GO
CREATE NONCLUSTERED INDEX IX_TFileImportItem_FileImportHeaderId_Status ON dbo.TFileImportItem
	(
	FileImportHeaderId,
	[Status]
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_TFileImportItem_FileImportHeaderId_FileImportItemId_RowNumber] ON [dbo].[TFileImportItem] 
(
	[FileImportHeaderId] ASC,
	[FileImportItemId] ASC,
	[RowNumber] ASC
)
INCLUDE ( [RowData],
[Status],
[Message]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]


CREATE NONCLUSTERED INDEX [IX_TFileImportItem_FileImportHeaderId_RowNumber] ON [dbo].[TFileImportItem] 
(
	[FileImportHeaderId] ASC,
	[RowNumber] ASC
)
INCLUDE ( [FileImportItemId],
[RowData],
[Status],
[Message]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]


