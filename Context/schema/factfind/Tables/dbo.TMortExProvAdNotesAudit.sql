CREATE TABLE [dbo].[TMortExProvAdNotesAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[AdditionalNotes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TMortExProvAdNotesAudit_ConcurrencyId] DEFAULT ((1)),
[MortExProvAdNotesId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TMortExProvAdNotesAudit] ADD CONSTRAINT [PK_TMortExProvAdNotesAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
