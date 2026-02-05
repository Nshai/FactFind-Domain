CREATE TABLE [dbo].[TLiabilityNotesAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[LiabilityNotes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[LiabilityNotesId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TLiabilit__Concu__088B3037] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TLiabilityNotesAudit] ADD CONSTRAINT [PK_TLiabilityNotesAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
