CREATE TABLE [dbo].[TEmploymentNoteAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ConcurrencyId] [int] NOT NULL,
[CRMContactId] [int] NOT NULL,
[Note] [varchar] (8000) COLLATE Latin1_General_CI_AS NULL,
[EmploymentNoteId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TEmploymentNoteAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEmploymentNoteAudit] ADD CONSTRAINT [PK_TEmploymentNoteAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TEmploymentNoteAudit_EmploymentNoteId_ConcurrencyId] ON [dbo].[TEmploymentNoteAudit] ([EmploymentNoteId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
