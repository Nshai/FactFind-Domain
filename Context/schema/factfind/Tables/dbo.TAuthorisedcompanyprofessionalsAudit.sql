CREATE TABLE [dbo].[TAuthorisedcompanyprofessionalsAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[Name] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[Position] [varchar] (512) COLLATE Latin1_General_CI_AS NULL,
[CRMContactId] [int] NOT NULL,
[AuthorisedcompanyprofessionalsId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF__TAuthoris__Concu__0C5BC11B] DEFAULT ((1)),
[STAMPACTION] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[STAMPDATETIME] [datetime] NULL,
[STAMPUSER] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TAuthorisedcompanyprofessionalsAudit] ADD CONSTRAINT [PK_TAuthorisedcompanyprofessionalsAudit] PRIMARY KEY CLUSTERED  ([AuditId])
GO
