CREATE TABLE [dbo].[TEmailQueueRecipientAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[EmailQueueId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[PolicyBusinessId] [int] NULL,
[StatusId] [int] NOT NULL,
[AddedToQueueDate] [datetime] NOT NULL CONSTRAINT [DF_TEmailQueueRecipientAudit_AddedToQueueDate] DEFAULT (getdate()),
[SentDate] [datetime] NULL,
[SentBody] [text] COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [char] (10) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_TEmailQueueRecipientAudit_ConcurrencyId] DEFAULT ((1)),
[EmailQueueRecipientId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TEmailQueueRecipientAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL,
[FeeId] [int] NULL,
[LeadId] [int] NULL,
)
GO
ALTER TABLE [dbo].[TEmailQueueRecipientAudit] ADD CONSTRAINT [PK_TEmailQueueRecipientAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
