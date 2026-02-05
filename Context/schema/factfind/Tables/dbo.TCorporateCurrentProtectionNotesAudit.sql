CREATE TABLE [dbo].[TCorporateCurrentProtectionNotesAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Notes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[CorporateCurrentProtectionNotesId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TCorporateCurrentProtectionNotesAudit__ConcurrencyId] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TCorporateCurrentProtectionNotesAudit] ADD CONSTRAINT [PK_TCorporateCurrentProtectionNotesAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
