CREATE TABLE [dbo].[TXMLSentAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[QuoteId] [int] NOT NULL,
[QuoteItemId] [int] NULL,
[RefXMLMessageTypeId] [int] NOT NULL,
[XMLSentData] [text] COLLATE Latin1_General_CI_AS NULL,
[SentDate] [datetime] NOT NULL,
[IsLatest] [bit] NOT NULL CONSTRAINT [DF_TXMLSentAudit_IsLatest] DEFAULT ((0)),
[UserId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TXMLSentAudit_ConcurrencyId] DEFAULT ((1)),
[XMLSentId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TXMLSentAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TXMLSentAudit] ADD CONSTRAINT [PK_TXMLSentAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDX_TXMLSentAudit_XMLSentId_ConcurrencyId] ON [dbo].[TXMLSentAudit] ([XMLSentId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
