CREATE TABLE [dbo].[TPolicyBusinessNoteAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[PolicyBusinessId] [int] NOT NULL,
[Note] [varchar] (8000) COLLATE Latin1_General_CI_AS NULL,
[UserId] [int] NULL,
[DateTime] [datetime] NOT NULL,
[IsLatest] [bit] NOT NULL CONSTRAINT [DF_TPolicyBusinessNoteAudit_IsLatest] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TPolicyBusinessNoteAudit_ConcurrencyId] DEFAULT ((1)),
[PolicyBusinessNoteId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TPolicyBusinessNoteAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TPolicyBusinessNoteAudit] ADD CONSTRAINT [PK_TPolicyBusinessNoteAudit_AuditId] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TPolicyBusinessNoteAudit_PolicyBusinessNoteId_ConcurrencyId] ON [dbo].[TPolicyBusinessNoteAudit] ([PolicyBusinessNoteId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
