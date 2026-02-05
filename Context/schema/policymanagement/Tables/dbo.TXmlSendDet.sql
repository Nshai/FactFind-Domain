CREATE TABLE [dbo].[TXmlSendDet]
(
[XmlSendDetId] [int] NOT NULL IDENTITY(1, 1),
[XmlSendId] [int] NULL,
[DocVersionId] [int] NULL,
[ProductId] [int] NULL,
[IFARef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ClientRef] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[XmlRequest] [text] COLLATE Latin1_General_CI_AS NULL,
[RequestSentFG] [bit] NULL,
[QVTPolicyFG] [bit] NULL,
[TransmissionMethod] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[DeclareRefDate] [datetime] NULL,
[DeclareDate] [datetime] NULL,
[DeclareTime] [datetime] NULL,
[DeclareIFACaseRefNo] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[DeclareSignedFG] [bit] NULL,
[MsgCompletedFG] [bit] NULL,
[LastUpdatedDate] [datetime] NULL,
[Owner] [tinyint] NULL,
[ETransferMoneyFG] [bit] NULL,
[XmlResponse] [text] COLLATE Latin1_General_CI_AS NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NULL CONSTRAINT [DF_TXmlSendDe_ConcurrencyId_1__63] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TXmlSendDet] ADD CONSTRAINT [PK_TXmlSendDet_2__63] PRIMARY KEY NONCLUSTERED  ([XmlSendDetId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TXmlSendDet_ProductId] ON [dbo].[TXmlSendDet] ([ProductId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TXmlSendDet_XmlSendId] ON [dbo].[TXmlSendDet] ([XmlSendId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TXmlSendDet] ADD CONSTRAINT [FK_TXmlSendDet_ProductId_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [dbo].[TProduct] ([ProductId])
GO
ALTER TABLE [dbo].[TXmlSendDet] ADD CONSTRAINT [FK_TXmlSendDet_XmlSendId_XmlSendId] FOREIGN KEY ([XmlSendId]) REFERENCES [dbo].[TXmlSend] ([XmlSendId])
GO
