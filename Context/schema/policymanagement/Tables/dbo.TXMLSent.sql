CREATE TABLE [dbo].[TXMLSent]
(
[XMLSentId] [int] NOT NULL IDENTITY(1, 1),
[QuoteId] [int] NOT NULL,
[QuoteItemId] [int] NULL,
[RefXMLMessageTypeId] [int] NOT NULL,
[XMLSentData] [text] COLLATE Latin1_General_CI_AS NULL,
[SentDate] [datetime] NOT NULL,
[IsLatest] [bit] NOT NULL CONSTRAINT [DF_TXMLSent_IsLatest] DEFAULT ((0)),
[UserId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TXMLSent_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TXMLSent] ADD CONSTRAINT [PK_TXMLSent] PRIMARY KEY NONCLUSTERED  ([XMLSentId]) WITH (FILLFACTOR=80)
GO
CREATE CLUSTERED INDEX [IDX_TXMLSent] ON [dbo].[TXMLSent] ([QuoteId]) WITH (FILLFACTOR=80)
GO
