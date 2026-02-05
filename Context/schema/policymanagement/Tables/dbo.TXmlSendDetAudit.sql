CREATE TABLE [dbo].[TXmlSendDetAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
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
[ConcurrencyId] [int] NULL,
[XmlSendDetId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TXmlSendDe_StampDateTime_1__52] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TXmlSendDetAudit] ADD CONSTRAINT [PK_TXmlSendDetAudit_2__52] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TXmlSendDetAudit_XmlSendDetId_ConcurrencyId] ON [dbo].[TXmlSendDetAudit] ([XmlSendDetId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
