CREATE TABLE [dbo].[TEquityReleaseNotesAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[CRMContactId] [int] NOT NULL,
[AdditionalNotes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TEquityReleaseNotesAudit_ConcurrencyId] DEFAULT ((1)),
[EquityReleaseNotesId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL,
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TEquityReleaseNotesAudit] ADD CONSTRAINT [PK_TEquityReleaseNotesAudit] PRIMARY KEY NONCLUSTERED  ([AuditId])
GO
