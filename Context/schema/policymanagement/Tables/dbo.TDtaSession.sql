CREATE TABLE [dbo].[TDtaSession]
(
[DtaSessionId] [uniqueidentifier] NOT NULL,
[CorrelationId] [uniqueidentifier] NOT NULL,
[UserId] [int] NOT NULL,
[TenantId] [int] NOT NULL,
[CreatedDate] [datetime] NOT NULL,
[Request] [varchar](max) NULL,
[Response] [varchar](max) NULL
)
GO
ALTER TABLE [dbo].[TDtaSession] ADD CONSTRAINT [PK_TDtaSession] PRIMARY KEY CLUSTERED  ([DtaSessionId])
GO
CREATE NONCLUSTERED INDEX [IX_TDtaSession_CorrelationId] ON [dbo].[TDtaSession] ([CorrelationId])
GO
CREATE NONCLUSTERED INDEX [IX_TDtaSession_CreatedDate] ON [dbo].[TDtaSession] ([CreatedDate])
GO
CREATE NONCLUSTERED INDEX [IX_TDtaSession_TenantId] ON [dbo].[TDtaSession] ([TenantId])
GO
CREATE NONCLUSTERED INDEX [IX_TDtaSession_UserId] ON [dbo].[TDtaSession] ([UserId])
GO
