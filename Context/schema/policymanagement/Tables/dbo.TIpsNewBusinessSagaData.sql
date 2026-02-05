CREATE TABLE [dbo].[TIpsNewBusinessSagaData]
(
[IpsNewBusinessSagaDataId] [uniqueidentifier] NOT NULL,
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
[ResultsMessage] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ClientErrorMessage] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[SystemErrorMessage] [varchar] (max) COLLATE Latin1_General_CI_AS NULL,
[NewClientSagaCorrelationId] [uniqueidentifier] NULL
)
GO
ALTER TABLE [dbo].[TIpsNewBusinessSagaData] ADD CONSTRAINT [PK_TIpsNewBusinessSagaData] PRIMARY KEY CLUSTERED  ([IpsNewBusinessSagaDataId])
GO
ALTER TABLE [dbo].[TIpsNewBusinessSagaData] ADD  CONSTRAINT [DF_TIpsNewBusinessSagaData_SelectedUserId]  DEFAULT ((0)) FOR [SelectedUserId]
GO