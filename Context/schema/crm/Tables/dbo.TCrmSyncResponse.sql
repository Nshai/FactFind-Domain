CREATE TABLE [dbo].[TCrmSyncResponse]
(
[CrmSyncResponseId] [int] NOT NULL IDENTITY(1, 1),
[CrmSyncRequestId] [uniqueidentifier] NOT NULL,
[RetryNumber] [smallint] NULL,
[RequestString] [varchar](max) NULL,
[ResponseString] [varchar](max) NULL,
[SystemError]  [bit] NULL,
[ErrorMessage] [varchar](max) NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCrmSyncResponse_ConcurrencyId] DEFAULT ((1)),
)
GO
ALTER TABLE [dbo].[TCrmSyncResponse] ADD CONSTRAINT [PK_TCrmSyncResponse] PRIMARY KEY CLUSTERED  ([CrmSyncResponseId])
GO