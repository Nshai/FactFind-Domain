CREATE TABLE [dbo].[TValBulkRequestAudit]
(
[ValBulkRequestAuditId] [int] NOT NULL IDENTITY(1, 1),
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
[ConcurrencyId] [int] NOT NULL,
[ValBulkRequestId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TValBulkRequestAudit] ADD CONSTRAINT [PK_TValBulkRequestAudit] PRIMARY KEY CLUSTERED  ([ValBulkRequestAuditId])
GO
