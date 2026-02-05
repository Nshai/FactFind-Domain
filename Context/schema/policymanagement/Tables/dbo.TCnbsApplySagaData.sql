CREATE TABLE [dbo].[TCnbsApplySagaData]
(
[CnbsApplySagaDataId] [uniqueidentifier] NOT NULL,
[Originator] [nvarchar] (2048) COLLATE Latin1_General_CI_AS NOT NULL,
[OriginalMessageId] [nvarchar] (2048) COLLATE Latin1_General_CI_AS NOT NULL,
[IsDeleted] [bit] NULL,
[PolicyBusinessIds] [xml] NOT NULL,
[PortalId] [int] NOT NULL,
[SelectedUserPartyId] [int] NOT NULL,
[ClientPartyId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[LoggedOnUserId] [int] NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_TCnbsQuoteSagaData_CreatedDate] DEFAULT (getdate()),
[ClientErrorMessage] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[SystemErrorMessage] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[AqsReference] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[AqsApplyReference] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[ExternalReference] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[StartSendDateTime] [datetime] NULL,
[EndSendDateTime] [datetime] NULL,
[MessagePosted] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[MessageResponseFromPost] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ResponseMessage] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ResponseRecievedDateTime] [datetime] NULL,
[TimedOutAt] [datetime] NULL
)
GO
ALTER TABLE [dbo].[TCnbsApplySagaData] ADD CONSTRAINT [PK_TCnbsApplySagaData] PRIMARY KEY CLUSTERED  ([CnbsApplySagaDataId])
GO
