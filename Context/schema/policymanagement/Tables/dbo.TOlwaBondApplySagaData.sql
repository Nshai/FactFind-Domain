CREATE TABLE [dbo].[TOlwaBondApplySagaData]
(
[OlwaBondApplySagaDataId] [uniqueidentifier] NOT NULL,
[Originator] [nvarchar] (2048) COLLATE Latin1_General_CI_AS NOT NULL,
[OriginalMessageId] [nvarchar] (2048) COLLATE Latin1_General_CI_AS NOT NULL,
[PortalId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[SelectedUserPartyId] [int] NOT NULL,
[ClientPartyId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[IsDeleted] [bit] NULL,
[ExternalCaseReference] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[LoggedOnUserId] [int] NULL,
[CreatedDate] [datetime] NOT NULL CONSTRAINT [DF_TOlwaBondApplySagaData_CreatedDate] DEFAULT (getdate()),
[StartSendDateTime] [datetime] NULL,
[EndSendDateTime] [datetime] NULL,
[ResponseRecievedDateTime] [datetime] NULL,
[MessagePosted] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[MessageResponseFromPost] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ClientErrorMessage] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[SystemErrorMessage] [varchar] (max) COLLATE Latin1_General_CI_AS NULL
)
GO
