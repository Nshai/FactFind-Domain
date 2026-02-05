CREATE TABLE [dbo].[TAqsQuoteSagaData]
(
[AqsQuoteSagaDataId] [uniqueidentifier] NOT NULL,
[Originator] [nvarchar] (2048) COLLATE Latin1_General_CI_AS NOT NULL,
[OriginalMessageId] [nvarchar] (2048) COLLATE Latin1_General_CI_AS NOT NULL,
[PortalId] [int] NOT NULL,
[SelectedUserPartyId] [int] NOT NULL,
[ClientPartyId] [int] NOT NULL,
[SecondClientPartyId] [int] NULL,
[QuoteId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[IsDeleted] [bit] NULL,
[AqsReference] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[LoggedOnUserId] [int] NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_TAqsQuoteSagaData_CreatedDate] DEFAULT (getdate()),
[RequestStartSendDateTime] [datetime] NULL,
[RequestEndSendDateTime] [datetime] NULL,
[ResponseRecievedDateTime] [datetime] NULL,
[MessagePosted] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[MessageResponseFromPost] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ClientErrorMessage] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[SystemErrorMessage] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ResultsMessageReceivedDateTime] [datetime] NULL,
[ResultsMessage] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[FinancialPlanningScenarioId] [int] NULL,
[DocumentDownloadMessageReceivedDateTime] [datetime] NULL,
[ServiceCaseId] [int] NULL
)
GO
ALTER TABLE [dbo].[TAqsQuoteSagaData] ADD CONSTRAINT [PK_TAqsQuoteSagaData] PRIMARY KEY CLUSTERED  ([AqsQuoteSagaDataId])
GO
