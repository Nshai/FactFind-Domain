CREATE TABLE [dbo].[TOlwiBondQuoteSagaData]
(
[OlwiBondQuoteSagaDataId] [uniqueidentifier] NOT NULL,
[Originator] [nvarchar] (2048) COLLATE Latin1_General_CI_AS NOT NULL,
[OriginalMessageId] [nvarchar] (2048) COLLATE Latin1_General_CI_AS NOT NULL,
[PortalId] [int] NOT NULL,
[SelectedUserPartyId] [int] NOT NULL,
[ClientPartyId] [int] NOT NULL,
[SecondClientPartyId] [int] NULL,
[QuoteId] [int] NOT NULL,
[FinancialPlanningScenarioId] [int] NULL,
[TenantId] [int] NOT NULL,
[IsDeleted] [bit] NULL,
[ExternalCaseReference] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[LoggedOnUserId] [int] NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_TOlwiBondQuoteSagaData_CreatedDate] DEFAULT (getdate()),
[RequestStartSendDateTime] [datetime] NULL,
[RequestEndSendDateTime] [datetime] NULL,
[ResponseRecievedDateTime] [datetime] NULL,
[MessagePosted] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[MessageResponseFromPost] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ResultsMessageReceivedDateTime] [datetime] NULL,
[DocumentDownloadMessageReceivedDateTime] [datetime] NULL,
[ResultsMessage] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ClientErrorMessage] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[SystemErrorMessage] [varchar] (max) COLLATE Latin1_General_CI_AS NULL
)
GO
