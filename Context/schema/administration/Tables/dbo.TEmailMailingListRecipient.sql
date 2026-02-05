CREATE TABLE [dbo].[TEmailMailingListRecipient]
(
[EmailMailingListRecipientId] [int] NOT NULL IDENTITY(1, 1),
[EmailMailingListId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEmailMailingListRecipient_ConcurrencyId] DEFAULT ((1))
)
GO
ALTER TABLE [dbo].[TEmailMailingListRecipient] ADD CONSTRAINT [PK_TEmailMailingListRecipient_EmailMailingListRecipientId] PRIMARY KEY NONCLUSTERED  ([EmailMailingListRecipientId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IX_TEmailMailingListRecipient_EmailMailingListIdASC] ON [dbo].[TEmailMailingListRecipient] ([EmailMailingListId]) WITH (FILLFACTOR=80)
GO
