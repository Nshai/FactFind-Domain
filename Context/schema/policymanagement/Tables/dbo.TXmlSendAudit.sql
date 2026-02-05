CREATE TABLE [dbo].[TXmlSendAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IndUserId] [int] NULL,
[CRMContactId] [int] NULL,
[XmlSendDate] [datetime] NULL,
[GuidReference] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[RefQuoteStatusId] [int] NULL,
[Extensible] [dbo].[extensible] NULL,
[ConcurrencyId] [int] NOT NULL,
[XmlSendId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TXmlSendAu_StampDateTime_1__78] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TXmlSendAudit] ADD CONSTRAINT [PK_TXmlSendAudit_2__78] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TXmlSendAudit_XmlSendId_ConcurrencyId] ON [dbo].[TXmlSendAudit] ([XmlSendId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
