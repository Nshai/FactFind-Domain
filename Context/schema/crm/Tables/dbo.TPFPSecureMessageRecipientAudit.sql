CREATE TABLE [dbo].[TPFPSecureMessageRecipientAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PFPSecureMessageRecipientId] [int] NOT NULL,
[PFPSecureMessageId] [int] NULL,
[SecureMessageUserId] [int] NULL,
[ClientUserId] [int] NULL,
[AdviserUserId] [int] NULL,
[ConcurrencyId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPFPSecureMessageRecipientAudit] ADD CONSTRAINT [PK_TPFPSecureMessageRecipientAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
