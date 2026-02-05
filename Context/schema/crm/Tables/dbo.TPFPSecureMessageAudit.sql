CREATE TABLE [dbo].[TPFPSecureMessageAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[IsRead] [bit] NOT NULL,
[IsReplied] [bit] NOT NULL,
[Status] [int] NOT NULL,
[Subject] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Body] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[SentTimeStamp] [datetime] NULL,
[ReceivedTimeStamp] [datetime] NULL,
[ConcurrencyId] [int] NOT NULL,
[PFPSecureMessageId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[ProxyAdviserUserId] [int] NULL,
[ReplyPFPSecureMessageId] [int] NULL,
[TenantId] [int] NULL,
[SenderUserId] [int] NULL,
[IsReadReceiptRequested] [bit] NULL,
[ReadOnTimeStamp] [datetime] NULL
)
GO
ALTER TABLE [dbo].[TPFPSecureMessageAudit] ADD CONSTRAINT [PK_TPFPSecureMessageAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
