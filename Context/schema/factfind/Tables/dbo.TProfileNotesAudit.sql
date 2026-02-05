CREATE TABLE [dbo].[TProfileNotesAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Notes] [varchar] (5000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[ProfileNotesId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TProfileN__Concu__58A712EB] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TProfileNotesAudit] ADD CONSTRAINT [PK_TProfileNotesAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
