CREATE TABLE [dbo].[TDependantsNotesAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[DisabledDependantsYN] [bit] NULL,
[DisabledNotes] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[DependantsNotesId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TDependan__Concu__06A2E7C5] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TDependantsNotesAudit] ADD CONSTRAINT [PK_TDependantsNotesAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
