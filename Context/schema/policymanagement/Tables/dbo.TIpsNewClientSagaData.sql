CREATE TABLE [dbo].[TIpsNewClientSagaData]
(
[IpsNewClientSagaDataId] [uniqueidentifier] NOT NULL,
[Originator] [nvarchar] (2048) COLLATE Latin1_General_CI_AS NOT NULL,
[OriginalMessageId] [nvarchar] (2048) COLLATE Latin1_General_CI_AS NOT NULL,
[IsDeleted] [bit] NULL,
[CreatedDate] [datetime] NOT NULL,
[TenantId] [int] NOT NULL,
[LoggedOnUserId] [int] NOT NULL,
[SelectedUserId] [int] NOT NULL,
[PolicyBusinessId] [int] NOT NULL,
[PartyId] [int] NOT NULL,
[RequestStartSendDateTime] [datetime] NULL,
[ResponseReceivedDateTime] [datetime] NULL,
[MessagePosted] [xml] NULL,
[MessageResponseFromPost] [xml] NULL,
[ResultsMessage] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ClientErrorMessage] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[SystemErrorMessage] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[PortalId] [int] NOT NULL,
[ProductTypeCode] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IntegratedSystemCode] [nvarchar] (255) COLLATE Latin1_General_CI_AS NOT NULL
)
GO
ALTER TABLE [dbo].[TIpsNewClientSagaData] ADD CONSTRAINT [PK_TIpsClientSagaData] PRIMARY KEY CLUSTERED  ([IpsNewClientSagaDataId])
GO
ALTER TABLE [dbo].[TIpsNewClientSagaData] ADD  CONSTRAINT [DF_TIpsNewClientSagaData_SelectedUserId]  DEFAULT ((0)) FOR [SelectedUserId]
GO