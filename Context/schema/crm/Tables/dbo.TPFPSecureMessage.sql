CREATE TABLE [dbo].[TPFPSecureMessage]
(
[PFPSecureMessageId] [int] NOT NULL IDENTITY(1, 1),
[TenantId] [int] NULL,
[SenderUserId] [int] NULL,
[Subject] [nvarchar] (255) COLLATE Latin1_General_CI_AS NULL,
[Body] [nvarchar] (max) COLLATE Latin1_General_CI_AS NULL,
[BodyPreview] [nvarchar] (200) COLLATE Latin1_General_CI_AS NULL,
[Status] [int] NOT NULL,
[SentTimeStamp] [datetime] NULL,
[ReceivedTimeStamp] [datetime] NULL,
[ReplyPFPSecureMessageId] [int] NULL,
[IsHtml] [bit] NOT NULL CONSTRAINT [DF_TPFPSecureMessage_IsHtml] DEFAULT ((0)),
[IsRead] [bit] NOT NULL CONSTRAINT [DF_TPFPSecureMessage_IsRead] DEFAULT ((0)),
[IsReplied] [bit] NOT NULL CONSTRAINT [DF_TPFPSecureMessage_IsReplied] DEFAULT ((0)),
[CanReply] [bit] NULL,
[ProxyAdviserUserId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPFPSecureMessage_ConcurrencyId] DEFAULT ((1)),
[IsReadReceiptRequested] [bit] NOT NULL CONSTRAINT [DF_TPFPSecureMessage_IsReadReceiptRequested] DEFAULT ((0)),
[ReadOnTimeStamp] [datetime] NULL
)
GO
ALTER TABLE [dbo].[TPFPSecureMessage] ADD CONSTRAINT [PK_TPFPSecureMessageId] PRIMARY KEY CLUSTERED  ([PFPSecureMessageId])
GO
CREATE NONCLUSTERED INDEX [IX_TPFPSecureMessage_Status_IsRead] ON [dbo].[TPFPSecureMessage] ([Status], [IsRead])
GO
ALTER TABLE [dbo].[TPFPSecureMessage] ADD CONSTRAINT [FK_TPFPSecureMessage_TRefPFPSecureMessageStatus] FOREIGN KEY ([Status]) REFERENCES [dbo].[TRefPFPSecureMessageStatus] ([RefPFPSecureMessageStatusId])
GO
