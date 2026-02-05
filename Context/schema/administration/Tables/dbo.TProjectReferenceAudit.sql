CREATE TABLE [dbo].[TProjectReferenceAudit]
(
[AuditId] [int] NOT NULL IDENTITY(1, 1),
[ProjectReferenceName] [varchar] (255) COLLATE Latin1_General_CI_AS NOT NULL,
[IndigoClientId] [int] NOT NULL,
[ConcurrencyId] [int] NOT NULL CONSTRAINT [DF_TProjectReferenceAudit_ConcurrencyId] DEFAULT ((1)),
[ProjectReferenceId] [int] NOT NULL,
[StampAction] [char] (1) COLLATE Latin1_General_CI_AS NOT NULL,
[StampDateTime] [datetime] NULL CONSTRAINT [DF_TProjectReferenceAudit_StampDateTime] DEFAULT (getdate()),
[StampUser] [varchar] (255) COLLATE Latin1_General_CI_AS NULL
)
GO
ALTER TABLE [dbo].[TProjectReferenceAudit] ADD CONSTRAINT [PK_TProjectReferenceAudit] PRIMARY KEY NONCLUSTERED  ([AuditId]) WITH (FILLFACTOR=80)
GO
