CREATE TABLE [dbo].[TClientTypeNotesAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ClientTypeNotes] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[ClientTypeNotesId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TClientTypeNotesAudit__ConcurrencyId] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TClientTypeNotesAudit] ADD CONSTRAINT [PK_TClientTypeNotesAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
