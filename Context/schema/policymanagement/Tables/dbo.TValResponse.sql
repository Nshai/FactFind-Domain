CREATE TABLE [dbo].[TValResponse]
(
[ValResponseId] [int] NOT NULL IDENTITY(1, 1),
[ValRequestId] [int] NOT NULL,
[ImplementationCode] [varchar] (100)  NULL,
[ResponseXML] [text]  NULL,
[ResponseDate] [datetime] NULL,
[ResponseStatus] [varchar] (255)  NULL,
[ErrorDescription] [varchar] (4000)  NULL,
[ProviderErrorCode] [varchar] (50)  NULL,
[ProviderErrorDescription] [varchar] (1000)  NULL,
[IsAnalysed] [bit] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TValResponse_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TValResponse] ADD CONSTRAINT [PK_TValResponse] PRIMARY KEY CLUSTERED  ([ValResponseId])
GO
CREATE NONCLUSTERED INDEX [IX_TValResponse_ValRequestId] ON [dbo].[TValResponse] ([ValRequestId])
GO
