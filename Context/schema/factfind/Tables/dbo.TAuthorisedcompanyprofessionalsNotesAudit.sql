CREATE TABLE [dbo].[TAuthorisedcompanyprofessionalsNotesAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Notes] [varchar] (4000) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[AuthorisedcompanyprofessionalsNotesId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TAuthoris__Concu__41C3AD93] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAuthorisedcompanyprofessionalsNotesAudit] ADD CONSTRAINT [PK_TAuthorisedcompanyprofessionalsNotesAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
