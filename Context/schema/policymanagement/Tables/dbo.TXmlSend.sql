CREATE TABLE [dbo].[TXmlSend]
(
[XmlSendId] [int] NOT NULL IDENTITY(1, 1),
[IndUserId] [int] NULL,
[CRMContactId] [int] NULL,
[XmlSendDate] [datetime] NULL,
[GuidReference] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RefQuoteStatusId] [int] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TXmlSend_ConcurrencyId_1__63] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TXmlSend] ADD CONSTRAINT [PK_TXmlSend_2__63] PRIMARY KEY NONCLUSTERED  ([XmlSendId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TXmlSend_RefQuoteStatusId] ON [dbo].[TXmlSend] ([RefQuoteStatusId]) WITH (FILLFACTOR=80)
GO
