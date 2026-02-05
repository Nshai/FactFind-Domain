CREATE TABLE [dbo].[TDeclarationNotesAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[DeclarationNotes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TDeclarationNotesAudit_ConcurrencyId] DEFAULT ((1)),
[DeclarationNotesId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TDeclarationNotesAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TDeclarationNotesAudit] ADD CONSTRAINT [PK_TDeclarationNotesAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
CREATE NONCLUSTERED INDEX [IDX_TDeclarationNotesAudit_DeclarationNotesId_ConcurrencyId] ON [dbo].[TDeclarationNotesAudit] ([DeclarationNotesId], [ConcurrencyId]) WITH (FILLFACTOR=90)
GO
