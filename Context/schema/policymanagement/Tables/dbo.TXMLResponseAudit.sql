CREATE TABLE [dbo].[TXMLResponseAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[QuoteId] [int] NOT NULL,
[RefXMLMessageTypeId] [int] NOT NULL,
[XMLResponseData] [text] COLLATE Latin1_General_CI_AS NULL,
[ResponseDate] [datetime] NOT NULL,
[IsLatest] [bit] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TXMLResponseAudit_ConcurrencyId] DEFAULT ((1)),
[XMLResponseId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TXMLResponseAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TXMLResponseAudit] ADD CONSTRAINT [PK_TXMLResponseAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TXMLResponseAudit_XMLResponseId_ConcurrencyId] ON [dbo].[TXMLResponseAudit] ([XMLResponseId], [ConcurrencyId])
GO
create index IX_TXMLResponseAudit_StampDateTime on TXMLResponseAudit (StampDateTime) 
go