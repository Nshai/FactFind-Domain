CREATE TABLE [dbo].[TFEAnalyticsSagaData]
(
[FEAnalyticsSagaDataId] [uniqueidentifier] NOT NULL,
[Originator] [nvarchar] (2048) COLLATE Latin1_General_CI_AS NOT NULL,
[OriginalMessageId] [nvarchar] (2048) COLLATE Latin1_General_CI_AS NOT NULL,
[IsDeleted] [bit] NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_TFEAnalyticsSagaData_CreatedDate] DEFAULT (getdate()),
[TenantId] [int] NOT NULL,
[LoggedOnUserId] [int] NULL,
[ClientPartyId] [int] NOT NULL,
[RequestStartTime] [datetime] NULL,
[ResponseTime] [datetime] NULL,
[PrePopMessagePosted] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[PrePopResponseReceived] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[IntegratedSystemCode][varchar](50)COLLATE Latin1_General_CI_AS NULL,
[RepopMessageReceived] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[RepopMessagePosted] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ClientErrorMessage] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[SystemErrorMessage] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[LaunchSource] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[DocumentName] [varchar] (100) COLLATE Latin1_General_CI_AS NULL,
[Document] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[AdviceCaseId][int] null,
[PolicyBusinessId][int]null
)
GO
ALTER TABLE [dbo].[TFEAnalyticsSagaData] ADD CONSTRAINT [PK_TFEAnalyticsSagaData] PRIMARY KEY CLUSTERED  ([FEAnalyticsSagaDataId])
GO
