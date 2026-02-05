CREATE TABLE [dbo].[TEmailQueueRecipient]
(
[EmailQueueRecipientId] [int] NOT NULL IDENTITY(1, 1),
[EmailQueueId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[PolicyBusinessId] [int] NULL,
[StatusId] [int] NOT NULL,
[AddedToQueueDate] [datetime] NOT NULL CONSTRAINT [DF_TEmailQueueRecipients_AddedToQueueDate] DEFAULT (getdate()),
[SentDate] [datetime] NULL,
[SentBody] [text] COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [char] (10) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_TEmailQueueRecipients_ConcurrencyId] DEFAULT ((1)),
[FeeId] [int] NULL,
[LeadId] [int] NULL
)
GO
ALTER TABLE [dbo].[TEmailQueueRecipient] ADD CONSTRAINT [PK_TEmailQueueRecipients_EmailQueueRecipientsId] PRIMARY KEY NONCLUSTERED  ([EmailQueueRecipientId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TEmailQueueRecipient_EmailQueueIdASC] ON [dbo].[TEmailQueueRecipient] ([EmailQueueId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TEmailQueueRecipient_StatusIdASC] ON [dbo].[TEmailQueueRecipient] ([StatusId]) WITH (FILLFACTOR=80)
GO
ALTER TABLE [dbo].[TEmailQueueRecipient] ADD CONSTRAINT [FK_TEmailQueueRecipient_EmailQueueId_EmailQueueId] FOREIGN KEY ([EmailQueueId]) REFERENCES [dbo].[TEmailQueue] ([EmailQueueId])
GO
