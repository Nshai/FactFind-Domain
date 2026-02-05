CREATE TABLE [dbo].[TEmailMailingListRecipientAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[EmailMailingListId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEmailMailingListRecipientAudit_ConcurrencyId] DEFAULT ((1)),
[EmailMailingListRecipientId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TEmailMailingListRecipientAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEmailMailingListRecipientAudit] ADD CONSTRAINT [PK_TEmailMailingListRecipientAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
