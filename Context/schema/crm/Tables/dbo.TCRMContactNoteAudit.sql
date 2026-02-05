CREATE TABLE [dbo].[TCRMContactNoteAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[Note] [varchar] (8000) COLLATE Latin1_General_CI_AS NULL,
[UserId] [int] NULL,
[DateTime] [datetime] NOT NULL,
[IsLatest] [bit] NOT NULL CONSTRAINT [DF_TCRMContactNoteAudit_IsLatest] DEFAULT ((1)),
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TCRMContac_ConcurrencyId_2__74] DEFAULT ((1)),
[CRMContactNoteId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TCRMContac_StampDateTime_3__74] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TCRMContactNoteAudit] ADD CONSTRAINT [PK_TCRMContactNoteAudit_4__74] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
CREATE NONCLUSTERED INDEX [IDXAudit_TCRMContactNoteAudit_CRMContactNoteId_ConcurrencyId] ON [dbo].[TCRMContactNoteAudit] ([CRMContactNoteId], [ConcurrencyId]) WITH (FILLFACTOR=80)
GO
