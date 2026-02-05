CREATE TABLE [dbo].[TCurrentProtectionNotesAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Notes] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[CurrentProtectionNotesId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TCurrentP__Concu__4964CF5B] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TCurrentProtectionNotesAudit] ADD CONSTRAINT [PK_TCurrentProtectionNotesAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
