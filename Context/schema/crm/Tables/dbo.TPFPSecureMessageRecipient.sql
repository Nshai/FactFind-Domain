CREATE TABLE [dbo].[TPFPSecureMessageRecipient]
(
[PFPSecureMessageRecipientId] [int] NOT NULL IDENTITY(1, 1),
[PFPSecureMessageId] [int] NULL,
[SecureMessageUserId] [int] NULL,
[ClientUserId] [int] NULL,
[AdviserUserId] [int] NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPFPSecureMessageRecipient_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TPFPSecureMessageRecipient] ADD CONSTRAINT [PK_TPFPSecureMessageRecipient] PRIMARY KEY CLUSTERED  ([PFPSecureMessageRecipientId])
GO
ALTER TABLE [dbo].[TPFPSecureMessageRecipient] ADD CONSTRAINT [FK_TPFPSecureMessageRecipient_TPFPSecureMessage] FOREIGN KEY ([PFPSecureMessageId]) REFERENCES [dbo].[TPFPSecureMessage] ([PFPSecureMessageId])
GO
ALTER TABLE [dbo].[TPFPSecureMessageRecipient] ADD CONSTRAINT [FK_TSecureMessageRecipient_TPFPSecureMessageUser] FOREIGN KEY ([SecureMessageUserId]) REFERENCES [dbo].[TSecureMessageUser] ([SecureMessageUserId])
GO
