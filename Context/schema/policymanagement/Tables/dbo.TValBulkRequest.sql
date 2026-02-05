CREATE TABLE [dbo].[TValBulkRequest]
(
[ValBulkRequestId] [int] NOT NULL IDENTITY(1, 1),
[ValScheduleId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[RefProdProviderId] [int] NOT NULL,
[Request] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[RequestDate] [datetime] NOT NULL,
[RequestType] [nvarchar] (50) COLLATE Latin1_General_CI_AS NOT NULL,
[Response] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[ThirdPartyRef] [nvarchar] (100) COLLATE Latin1_General_CI_AS NULL,
[ResponseDate] [datetime] NULL,
[StatusCode] [nvarchar] (10) COLLATE Latin1_General_CI_AS NULL,
[StatusDescription] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RequestGuid] [uniqueidentifier] NOT NULL,
[RequestedByUserId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValBulkRequest_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TValBulkRequest] ADD CONSTRAINT [PK_TValBulkRequest] PRIMARY KEY CLUSTERED  ([ValBulkRequestId])
GO
