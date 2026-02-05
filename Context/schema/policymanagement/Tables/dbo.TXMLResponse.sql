CREATE TABLE [dbo].[TXMLResponse]
(
[XMLResponseId] [int] NOT NULL IDENTITY(1, 1),
[QuoteId] [int] NOT NULL,
[RefXMLMessageTypeId] [int] NOT NULL,
[XMLResponseData] [text] COLLATE Latin1_General_CI_AS NULL,
[ResponseDate] [datetime] NOT NULL,
[IsLatest] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TXMLResponse_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TXMLResponse] ADD CONSTRAINT [PK_TXMLResponse] PRIMARY KEY NONCLUSTERED  ([XMLResponseId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IDX_TXMLResponse] ON [dbo].[TXMLResponse] ([QuoteId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TXMLResponse_QuoteId_RefXMLMessageTypeId_IsLatest] ON [dbo].[TXMLResponse] ([QuoteId], [RefXMLMessageTypeId], [IsLatest]) WITH (FILLFACTOR=80)
GO
