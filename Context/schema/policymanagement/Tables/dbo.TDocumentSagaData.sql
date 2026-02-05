create TABLE [dbo].TDocumentSagaData(
	[DocumentSagaDataId] [uniqueidentifier] NOT NULL,
	[CorrelationId] [uniqueidentifier] NOT NULL,
	[Originator] [nvarchar](2048) NOT NULL,
	[OriginalMessageId] [nvarchar](2048) NOT NULL,
	[IsDeleted] [bit] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[TenantId] [int] NOT NULL,
	[LoggedOnUserId] [int] NOT NULL,
	[SelectedUserPartyId] [int] NOT NULL,
	[PortalId] [int] NOT NULL,
	[PartyId] [int]  NULL,	
	[EntityId] [int] NOT NULL,
	[DocumentReference] [varchar](1000) NOT NULL,
	[DocumentTitle] [varchar](1000) NULL,
	[EntityType] [varchar](250) NULL,
	[RequestStartTime] [datetime] NULL,
	[RequestEndTime] [datetime] NULL,
	[RequestMessagePosted] [xml] NULL,
	[ResponseMessageReceived] [varchar](max) NULL,
	[ClientErrorMessage] [varchar](max) NULL,
	[SystemErrorMessage] [varchar](max) NULL,
	[IsCompleted] [bit] NULL
 CONSTRAINT [PK_TDocumentSagaData] PRIMARY KEY CLUSTERED 
(
	DocumentSagaDataId ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].TTDocumentSagaData ADD  CONSTRAINT [DF_TTDocumentSagaData_SelectedUserPartyId]  DEFAULT ((0)) FOR [SelectedUserPartyId]
GO
